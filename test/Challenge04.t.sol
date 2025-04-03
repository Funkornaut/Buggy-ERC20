// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge04} from "../src/Challenge04.sol";

contract Challenge04Test is Test {
    Challenge04 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        vm.startPrank(alice);
        challenge = new Challenge04();
        challenge.pause();
    }
    
    function test_TransferFromWorksWhenPaused(uint256 _amount) public {
        _amount = bound(_amount, 0, challenge.balanceOf(alice));
        uint256 aliceBalanceBeforeTransfer = challenge.balanceOf(alice);
        assertTrue(challenge.paused(), "Contract should be paused");

        challenge.approve(bob, _amount); // alice approves bob to spend _amount of her tokens
        vm.stopPrank();

        vm.prank(bob);
        bool success = challenge.transferFrom(alice, bob, _amount); // bob transfers _amount of alice's tokens to himself
        
        assertTrue(success, "TransferFrom should succeed even when paused");
        assertEq(
            challenge.balanceOf(alice), 
            aliceBalanceBeforeTransfer - _amount, 
            "Alice's balance should decrease"
        );
        assertEq(
            challenge.balanceOf(bob), 
            _amount, 
            "Bob's balance should increase"
        );
    }
} 