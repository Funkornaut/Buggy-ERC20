## Summary
The contract fails to enforce the pause state in the `transferFrom` function, creating a critical bypass of the intended security control.

## Vulnerability Details
While the `transfer` function correctly checks if the contract is paused, the `transferFrom` function does not implement this check. This inconsistency allows token transfers via `transferFrom` even when the contract is explicitly paused.

```solidity
// Vulnerable function missing pause check
function transferFrom(address from, address to, uint256 value) public returns (bool) {
    _spendAllowance(from, msg.sender, value);
    _transfer(from, to, value);
    return true;
}
```

## Impact
- High severity vulnerability
- The pause mechanism can be bypassed using the `transferFrom` function
- This undermines the security purpose of the pause functionality, which is meant to freeze all token transfers in emergency situations

## PoC

See test/Challenge4.t.sol

## Recommendation
Add the pause check to the internal `_transfer` function instead of individual transfer functions:

```solidity
function _transfer(address from, address to, uint256 value) internal {
    require(!paused, "Challenge4: transfers paused");
    require(to != address(0), "Challenge4: transfer to zero address");

    uint256 fromBalance = _balances[from];
    require(fromBalance >= value, "Challenge4: insufficient balance");

    _balances[from] = fromBalance - value;
    _balances[to] += value;
    emit Transfer(from, to, value);
}
```

This solution ensures all transfer operations respect the pause state, providing consistent security enforcement.
