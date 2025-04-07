// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge11} from "../src/Challenge11.sol";

contract Challenge11Test is Test {
    Challenge11 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        vm.prank(alice);
        challenge = new Challenge11();
        // Initialize any necessary state here
    }

    function test_Approvals() public {
        vm.prank(alice);
        challenge.approve(bob, 100);
        assertEq(challenge.allowance(alice, bob), 100);

        vm.prank(alice);
        challenge.increaseAllowance(bob, 100);
        assertEq(challenge.allowance(alice, bob), 200);

        assertEq(challenge.allowance(bob, alice), 0);
        vm.prank(bob);
        challenge.transferFrom(alice, bob, 100);
        assertEq(challenge.balanceOf(bob), 100);
        assertEq(challenge.allowance(alice, bob), 200); // bob's allowance should have been reduced by 100
        assertEq(challenge.allowance(bob, alice), 100); // alice's allowance should have stayed the same
    }
} 