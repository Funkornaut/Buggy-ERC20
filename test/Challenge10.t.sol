// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge10} from "../src/Challenge10.sol";

contract Challenge10Test is Test {
    Challenge10 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        challenge = new Challenge10();
        // Initialize any necessary state here
    }
} 