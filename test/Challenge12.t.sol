// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge12} from "../src/Challenge12.sol";

contract Challenge12Test is Test {
    Challenge12 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        challenge = new Challenge12("Challenge12", "CH12", 18);
        // Initialize any necessary state here
    }
} 