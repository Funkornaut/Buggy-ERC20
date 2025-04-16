// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge17} from "../src/Challenge17.sol";

contract Challenge17Test is Test {
    Challenge17 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        vm.prank(alice);
        challenge = new Challenge17();
        // Initialize any necessary state here
    }

    function test_TransferIsBroken() public {
        vm.prank(alice);
        challenge.transfer(bob, 100);
        assertEq(challenge.balanceOf(bob), 0); // should be 100
    }
} 