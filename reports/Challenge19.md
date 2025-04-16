## Summary
The Challenge19 token contract includes a hook `_beforeTokenTransfer` which can be overridden by child contracts. However, the `_transfer` function caches the sender’s balance (`fromBalance`) before invoking `_beforeTokenTransfer`, and uses that stale value for subtraction in an unchecked block. This introduces a critical inconsistency in balance accounting when the hook mutates the sender’s balance.

## Vulnerability Details
In Challenge19, the `_transfer` function performs the following steps:

```solidity
uint256 fromBalance = _balances[from];
_beforeTokenTransfer(from, to, amount);
require(fromBalance >= amount, "ERC20: transfer amount exceeds balance");
unchecked {
    _balances[from] = fromBalance - amount;
    _balances[to] += amount;
}
```
If a subclass overrides `_beforeTokenTransfer` to reduce the sender's balance (e.g., by calling _burn(from, X)), then the cached `fromBalance` is no longer valid. Despite the sender's balance being insufficient after the hook, the transfer will proceed as long as `fromBalance` (from before the hook) was large enough. This violates expected ERC20 accounting behavior and may allow users to transfer more tokens than they actually hold.

## Impact
- The transfer logic is based on an outdated balance snapshot.

- Token holders can transfer their entire balance even if part of it was burned or deducted during the `_beforeTokenTransfer` hook.

- Token accounting becomes inconsistent and could lead to unintentional inflation or exploit conditions in systems that depend on accurate balance tracking.

## PoC
See Challenge19.t.sol

## Reccomendation
Move the fromBalance read after the _beforeTokenTransfer hook to ensure it reflects the up-to-date balance.