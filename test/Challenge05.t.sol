// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge05} from "../src/Challenge05.sol";

contract Challenge05Test is Test {
    Challenge05 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        vm.prank(alice);
        challenge = new Challenge05();
    }

    function testTransferFromBug(uint256 _amount) public {
        _amount = bound(_amount, 0, challenge.balanceOf(alice));
        uint256 aliceInitialBalance = challenge.balanceOf(alice);
        uint256 bobInitialBalance = challenge.balanceOf(bob);
        
        // Bob approves Alice to spend tokens
        vm.prank(bob);
        challenge.approve(alice, _amount);
        
        // Alice tries to transfer tokens from Bob to herself
        // Due to the bug, tokens actually flow from Alice to Bob!
        vm.prank(alice);
        challenge.transferFrom(bob, alice, _amount);

        assertEq(challenge.balanceOf(alice), aliceInitialBalance - _amount);
        assertEq(challenge.balanceOf(bob), bobInitialBalance + _amount);
    }
} 