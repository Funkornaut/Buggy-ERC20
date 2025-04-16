// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge19} from "../src/Challenge19.sol";

contract VulnerableToken is Challenge19 {

    function _beforeTokenTransfer(address from, address to, uint256 amount) internal override {
        _burn(from, 10);
    }
}

contract Challenge19Test is Test {
    VulnerableToken public vulnerableToken;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        vm.prank(alice);
        vulnerableToken = new VulnerableToken();
    }
    
    function testUnderflowVulnerability() public {
        // Initial state
        assertEq(vulnerableToken.balanceOf(alice), 1000000 * 10 ** 18);
        assertEq(vulnerableToken.balanceOf(bob), 0);
        assertEq(vulnerableToken.totalSupply(), 1000000 * 10 ** 18);
        
        // Alice transfers her entire balance to Bob but burns 10 tokens in the process
        vm.prank(alice);
        vulnerableToken.transfer(bob, 1000000 * 10 ** 18);
        
        // Check final balances
        uint256 aliceFinalBalance = vulnerableToken.balanceOf(alice);
        uint256 bobFinalBalance = vulnerableToken.balanceOf(bob);
        
        // Because of a stale balance check, Bob will have the entire balance, Alice will have 0, and the total supply will be reduced by 10 breaking the total supply invariant
        assertEq(bobFinalBalance, 1000000 * 10 ** 18);
        assertEq(aliceFinalBalance, 0);
        assertEq(vulnerableToken.totalSupply(), 1000000 * 10 ** 18 - 10);
        
    }
} 