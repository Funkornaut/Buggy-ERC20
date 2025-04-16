// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge18} from "../src/Challenge18.sol";

contract Challenge18Test is Test {
    TestChallenge18 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        vm.prank(alice);
        challenge = new TestChallenge18();
        // Initialize any necessary state here
    }

    function test_MintDoesNotUpdateTotalSupplyBurnWillUnderflow() public {
        assertEq(challenge.totalSupply(), 0);
        
        vm.prank(alice);
        challenge.burn(1);
        assertEq(challenge.totalSupply(), type(uint256).max);
    }
        
} 

contract TestChallenge18 is Challenge18 {

    function burn(uint256 value) public {
        _burn(msg.sender, value);
    }
}