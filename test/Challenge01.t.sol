// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge01} from "../src/Challenge01.sol";

contract Challenge01Test is Test {
    Challenge01 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        challenge = new Challenge01("Challenge01", "CH01");
        challenge.mint(alice, 1000);
        challenge.mint(bob, 1000);
    }

    function test_transferNeverDecrements_from_balance() public {
        vm.prank(alice);
        challenge.transfer(bob, 100);
        assertEq(challenge.balanceOf(alice), 900); //@audit-issue from balance is never decremented
        assertEq(challenge.balanceOf(bob), 1100);
    }
}