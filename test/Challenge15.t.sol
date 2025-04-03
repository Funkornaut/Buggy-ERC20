// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge15} from "../src/Challenge15.sol";

contract Challenge15Test is Test {
    Challenge15 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        challenge = new Challenge15("Challenge15", "CH15", 18);
        // Initialize any necessary state here
    }
} 