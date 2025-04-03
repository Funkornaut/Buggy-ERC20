// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge07} from "../src/Challenge07.sol";

contract Challenge07Test is Test {
    Challenge07 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        challenge = new Challenge07();
    }
    
    function testUnprotectedMint(address randomMinter) public {
        // Initial supply check
        uint256 initialSupply = challenge.totalSupply();
        
        // Check randomMinter's initial balance (should be 0)
        assertEq(challenge.balanceOf(randomMinter), 0);
        
        // randomMinter mints 100 million tokens to themselves
        // This should not be possible, but is due to the unprotected mint function
        vm.prank(randomMinter);
        challenge.mint(randomMinter, 100_000_000 * 10**18);
        
        // Verify the randomMinter now has 100 million tokens
        assertEq(challenge.balanceOf(randomMinter), 100_000_000 * 10**18);
        // Verify total supply increased
        assertEq(challenge.totalSupply(), initialSupply + 100_000_000 * 10**18);

        vm.prank(alice);
        challenge.mint(alice, 100_000_000 * 10**18);
        
        // Verify the alice now has 100 million tokens
        assertEq(challenge.balanceOf(alice), 100_000_000 * 10**18);

        vm.prank(bob);
        challenge.mint(bob, 100_000_000 * 10**18);
        
        // Verify the bob now has 100 million tokens
        assertEq(challenge.balanceOf(bob), 100_000_000 * 10**18);
        
    }
} 