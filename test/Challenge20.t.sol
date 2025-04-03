// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge20} from "../src/Challenge20.sol";

contract Challenge20Test is Test {
    Challenge20 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        challenge = new Challenge20("Challenge20", "CH20", 18);
        // Initialize any necessary state here
    }
} 