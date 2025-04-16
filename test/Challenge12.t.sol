// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge12} from "../src/Challenge12.sol";

contract Challenge12Test is Test {
    Challenge12 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        vm.prank(alice);
        challenge = new TestChallenge12("Challenge12", "CH12", 18);
    }

    function test_GiftDoesNotUpdateTotalSupply() public {
        uint256 initialSupply = challenge.totalSupply();
        vm.prank(alice);
        challenge.gift(bob, 100);
        assertEq(challenge.totalSupply(), initialSupply);
    }
} 

contract TestChallenge12 is Challenge12 {
    constructor(string memory name, string memory symbol, uint8 decimals) Challenge12(name, symbol, decimals) {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public {
        _burn(from, amount);
    }

    function _mint(address to, uint256 amount) internal override {
        super._mint(to, amount);
    }

    function _burn(address from, uint256 amount) internal override {
        super._burn(from, amount);
    }
}