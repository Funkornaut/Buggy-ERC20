## Summary
The Challenge12 contract contains a critical accounting flaw in the `gift` function where tokens are added to user balances without updating the `totalSupply`.

## Vulnerability Details
The `gift` function increases a user's balance but doesn't update the `totalSupply`:
```solidity
function gift(address to, uint256 amount) public onlyOwner {
    balanceOf[to] += amount;
    emit Transfer(address(0), to, amount);
}
```
This creates an inconsistency between the sum of all balances and the reported total supply.

## Impact
This vulnerability breaks token accounting fundamentals:
1. The reported totalSupply will be lower than the actual circulating supply
2. Financial calculations based on totalSupply will be incorrect (market cap, etc.)
3. The token contract breaks the invariant that totalSupply should equal the sum of all balances

## PoC
See Challenge12.t.sol

## Reccomendation
Update the gift function to increase totalSupply:
```diff
function gift(address to, uint256 amount) public onlyOwner {
+   totalSupply += amount;
    balanceOf[to] += amount;
    emit Transfer(address(0), to, amount);
}
```