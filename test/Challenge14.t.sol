// SPDX-License-Identifier: CC-BY-NC-SA-4.0
pragma solidity ^0.8.20;

import {Test} from "forge-std/Test.sol";
import {Challenge14} from "../src/Challenge14.sol";

contract Challenge14Test is Test {
    Challenge14 public challenge;
    address public alice = makeAddr("Alice");
    address public bob = makeAddr("Bob");

    function setUp() public {
        challenge = new Challenge14("Challenge14", "CH14", 18);
        // Initialize any necessary state here
    }
} 