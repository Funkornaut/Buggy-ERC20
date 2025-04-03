// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge13} from "../src/Challenge13.sol";

contract Challenge13Test is Test {
    Challenge13 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        challenge = new Challenge13("Challenge13", "CH13", 18);
        // Initialize any necessary state here
    }
} 