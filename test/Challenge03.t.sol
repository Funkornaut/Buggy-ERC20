// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge03} from "../src/Challenge03.sol";

contract Challenge03Test is Test {
    Challenge03 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        vm.prank(alice);
        challenge = new Challenge03();
        // Initialize any necessary state here
    }

    function test_Burn(uint256 _amount) public {
        _amount = bound(_amount, 0, challenge.balanceOf(alice));

        uint256 aliceBalanceBeforeBurn = challenge.balanceOf(alice);
        uint256 totalSupplyBeforeBurn = challenge.totalSupply();
        vm.prank(bob);
        challenge.burn(alice, _amount);

        assertEq(challenge.balanceOf(alice), aliceBalanceBeforeBurn - _amount);
        assertEq(challenge.totalSupply(), totalSupplyBeforeBurn - _amount);
    }
} 