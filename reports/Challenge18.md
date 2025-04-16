## Summary
Challenge18 contains a critical accounting flaw where the `_mint` function fails to update the total supply, while the `_burn` function still decreases it. This mismatch causes a severe underflow in the total supply when tokens are burned.

## Vulnerability Details
There are two related issues in the code:
1. The _mint function doesn't update _totalSupply.
2. The _burn function still decreases _totalSupply in an unchecked block causing underflow.

## Impact
This vulnerability causes the token's accounting system to be completely broken:
1. The reported `totalSupply` will be zero despite tokens being minted
2. When burning tokens, `_totalSupply` will underflow to type(uint256).max (2^256-1)
3. This creates a massively inflated total supply that doesn't reflect reality
4. Any protocol relying on `totalSupply()` for financial calculations will be severely compromised

## PoC
See Challenge18.t.sol

## Reccomendation
1. Update the `mint` function to increase the `totalSupply` by the amount
2. Decrement the `totalSupply` outside of the unchecked block