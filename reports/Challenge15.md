## Summary
The Challenge15 contract contains a critical flaw in the _mint function where tokens are added to the total supply but not credited to any account, effectively creating "ghost tokens" that exist in the total supply but no one can access.

## Vulnerability Details
The _mint function increases the total supply but fails to update the recipient's balance.

## Impact
No one can get tokens.

## PoC
See Challenge15.t.sol

## Reccomendation
Add tokens to a users balance
```diff
function _mint(address to, uint256 amount) internal virtual {
    totalSupply += amount;
+   balanceOf[to] += amount;  
    emit Transfer(address(0), to, amount);
}
```