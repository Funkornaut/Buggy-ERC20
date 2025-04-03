// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge08} from "../src/Challenge08.sol";

contract Challenge08Test is Test {
    Challenge08 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        challenge = new Challenge08();
        // Initialize any necessary state here
    }
} 