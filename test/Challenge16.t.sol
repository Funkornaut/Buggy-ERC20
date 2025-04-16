// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge16} from "../src/Challenge16.sol";

contract Challenge16Test is Test {
    Challenge16 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        vm.prank(alice);
        challenge = new Challenge16();
        // Initialize any necessary state here
    }

    function test_Approve() public {
        vm.prank(alice);
        challenge.approve(bob, 100);
        assertEq(challenge.allowance(alice, bob), 0); 
    }
} 