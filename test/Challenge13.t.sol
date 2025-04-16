// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge13} from "../src/Challenge13.sol";

contract Challenge13Test is Test {
    TestChallenge13 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        challenge = new TestChallenge13("Challenge13", "CH13", 18);
        // Initialize any necessary state here
        challenge.mint(alice, 100);
        challenge.mint(bob, 100);
    }

    function test_ApproveIsBackwards() public {
        vm.prank(alice);
        challenge.approve(bob, 100);
       // assertEq(challenge.allowance(alice, bob), 100); this is what should happen
        assertEq(challenge.allowance(bob, alice), 100); // but the approve is backwards allowing alice to spend bob's tokens
        vm.prank(alice);
        challenge.transferFrom(bob, alice, 100);
        assertEq(challenge.balanceOf(alice), 200);
    }

} 

contract TestChallenge13 is Challenge13 {
    constructor(string memory name, string memory symbol, uint8 decimals) Challenge13(name, symbol, decimals) {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public {
        _burn(from, amount);
    }
}