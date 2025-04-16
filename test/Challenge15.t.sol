// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge15} from "../src/Challenge15.sol";

contract Challenge15Test is Test {
    TestChallenge15 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        challenge = new TestChallenge15("Challenge15", "CH15", 18);
    }

    function test_Mint() public {
        challenge.mint(alice, 100);
        assertEq(challenge.balanceOf(alice), 0); // should be 100
    }
} 

contract TestChallenge15 is Challenge15 {
    constructor(string memory name, string memory symbol, uint8 decimals) Challenge15(name, symbol, decimals) {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}