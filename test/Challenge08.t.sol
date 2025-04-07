// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge08} from "../src/Challenge08.sol";

contract Challenge08Test is Test {
    Challenge08 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        vm.prank(alice);
        challenge = new Challenge08();
        // Initialize any necessary state here
    }

    function test_BurnDoesNotDecreaseTotalSupply(uint256 _burnAmount) public {
        uint256 initialSupply = challenge.totalSupply();
        _burnAmount = bound(_burnAmount, 1, initialSupply);
        vm.prank(alice);
        challenge.burn(_burnAmount);
        // Total supply should have decreased by the burn amount but it doesn't
        assertEq(challenge.totalSupply(), initialSupply);
        assertEq(challenge.balanceOf(alice), initialSupply - _burnAmount);
    }
} 
