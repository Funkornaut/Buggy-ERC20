// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge14} from "../src/Challenge14.sol";

contract Challenge14Test is Test {
    TestChallenge14 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        challenge = new TestChallenge14("Challenge14", "CH14", 18);
        // Initialize any necessary state here
        challenge.mint(alice, 100);
        challenge.mint(bob, 100);
    }

    function test_ApproveIsNotDecrementedUnlessMaxedOut() public {
        vm.prank(alice);
        challenge.approve(bob, 50);
        assertEq(challenge.allowance(alice, bob), 50);

        vm.prank(bob);
        challenge.approve(alice, type(uint256).max);

        vm.prank(bob);
        challenge.transferFrom(alice, bob, 50);
        assertEq(challenge.allowance(alice, bob), 50); // still 50 because not maxed out

        vm.prank(bob);
        challenge.transferFrom(alice, bob, 50); // so bob can take 50 tokens more
        assertEq(challenge.allowance(alice, bob), 50); // still 50 because not maxed out
        assertEq(challenge.balanceOf(bob), 200);

        vm.prank(alice);
        challenge.transferFrom(bob, alice, 50);
        assertEq(challenge.allowance(bob, alice), (type(uint256).max - 50)); // allowance decreases because it was maxed out
    } 
}

contract TestChallenge14 is Challenge14 {
    constructor(string memory name, string memory symbol, uint8 decimals) Challenge14(name, symbol, decimals) {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}