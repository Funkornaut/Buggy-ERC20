## Summary
Challenge17 contains critical flaws in the `_transfer` function where both the balance check and the balance update are performed on the wrong accounts, completely breaking the basic functionality of the token.

## Vulnerability Details
The `_transfer` function has two major issues:
1. The balance check incorrectly verifies if the recipient (to) has sufficient tokens, instead of checking the sender (from).
2. The sender's balance update is wrong - it sets the sender's balance to the recipient's balance minus the transfer amount.

## Impact
This vulnerability completely breaks the token transfer functionality:
1. Transfers will revert if the recipient doesn't have enough tokens, even if the sender has plenty.
2. If the transfer succeeds, the sender's original balance is completely overwritten.
3. In cases where a recipient already has tokens, transfers would still leave the total supply incorrect.
4. Token accounting is fundamentally broken, making the entire contract unusable.

## PoC
See Challenge17.t.sol

## Reccomendation
Fix the _transfer function to check the sender's balance and update balances correctly:
```diff
function _transfer(address from, address to, uint256 value) internal {
    require(from != address(0), "ERC20: transfer from the zero address");
    require(to != address(0), "ERC20: transfer to the zero address");

-   uint256 toBalance = _balances[to];
-   require(toBalance >= value, "ERC20: transfer amount exceeds balance");
+   uint256 fromBalance = _balances[from];
+   require(fromBalance >= value, "ERC20: transfer amount exceeds balance");

-   _balances[from] = toBalance - value;
+   _balances[from] = fromBalance - value;
    _balances[to] += value;

    emit Transfer(from, to, value);
}
```