// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge18} from "../src/Challenge18.sol";

contract Challenge18Test is Test {
    Challenge18 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        challenge = new Challenge18();
        // Initialize any necessary state here
    }
} 