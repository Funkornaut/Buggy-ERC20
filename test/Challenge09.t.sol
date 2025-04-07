// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge09} from "../src/Challenge09.sol";

contract Challenge09Test is Test {
    Challenge09 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        vm.prank(alice);
        challenge = new Challenge09();
        // Initialize any necessary state here
    }

    function test_TransferUnderflow() public {
        vm.prank(bob);
        challenge.transfer(alice, 1);
        // Bob's balance should decrease by 1
        assertEq(challenge.balanceOf(bob), type(uint256).max);
        // Alice's balance should increase by 1
        assertEq(challenge.balanceOf(alice), challenge.totalSupply() + 1);
    }
} 
