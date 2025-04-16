# ERC-20 Spot the Bug Solutions

Solutions to Rare Skill's Buggy ERC20 Challenges.

This repository contains complete solutions for the [Rare Skills' Buggy ERC-20](https://github.com/RareSkills/erc20-bug-challenges) challenges, where each ERC-20 implementation contains a serious vulnerability.

## Contents

For each of the 20 challenges, this repository includes:

- Original buggy contract implementations in `/src`
- Test files in `/test` that demonstrate and exploit each vulnerability
- Detailed write-ups in `/reports` explaining each bug, its impact, and how it could be fixed

## About the Original Challenges

Buggy ERC-20 is a collection of 20 ERC-20 implementations with a bug injected in them.

These are serious bugs that could lead to catastrophic behavior, or significantly deviate from what the developer intended the behavior to be. Each implementation has a serious bug. While it is helpful to familiarize yourself with [weird ERC-20 tokens](https://github.com/d-xo/weird-erc20), the bugs we inserted here are much more problematic than the deviations described in the weird ERC-20 tokens repository.

It should be obvious, but **Do not use this code for production, it is for educational purposes.**

## How to Use This Repository

1. Review the original contract in `/src` (e.g., `Challenge01.sol`)
2. Read the corresponding write-up in `/reports` (e.g., `Challenge01.md`) to understand the vulnerability
3. Examine the test in `/test` (e.g., `Challenge01.t.sol`) to see how the vulnerability can be exploited

## Credits
The original challenges used the Solmate and OpenZeppelin ERC-20 implementations as starting points and were created by [BlockChomper](https://x.com/DegenShaker).

## License
This work is licensed under Creative Commons Attribution-NonCommercial-ShareAlike 4.0 International (CC BY-NC-SA 4.0)

Please see the full license [here](https://creativecommons.org/licenses/by-nc-sa/4.0/).

## Authors
The solutions where completed by [Funkornaut](https://warpcast.com/funkornaut)
The original buggy tokens were created by [BlockChomper](https://x.com/DegenShaker).
