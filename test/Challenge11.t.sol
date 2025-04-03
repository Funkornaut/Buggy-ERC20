// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge11} from "../src/Challenge11.sol";

contract Challenge11Test is Test {
    Challenge11 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        challenge = new Challenge11();
        // Initialize any necessary state here
    }
} 