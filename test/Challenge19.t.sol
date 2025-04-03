// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge19} from "../src/Challenge19.sol";

contract Challenge19Test is Test {
    Challenge19 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        challenge = new Challenge19();
        // Initialize any necessary state here
    }
} 