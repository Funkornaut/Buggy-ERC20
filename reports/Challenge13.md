## Summary
The `approve` function incorrectly updates the allowance mapping:
```solidity
function approve(address spender, uint256 amount) public virtual returns (bool) {
    allowance[spender][msg.sender] = amount; // INCORRECT: indices are swapped
    emit Approval(msg.sender, spender, amount);
    return true;
}
```

## Vulnerability Details
The first index should be the owner (msg.sender) and the second index should be the spender, but they are reversed. This means when a user calls approve, they're actually setting their allowance to spend the spender's tokens, not the other way around.

## Impact
This vulnerability allows any user to:
1. "Approve" any address to spend tokens
2. Immediately use transferFrom to steal tokens from that address
3. Drain any user's account without their permission

## PoC
See Challenge13.t.sol

## Reccomendation
Fix the indices in the approve function to follow the correct pattern:
```diff
function approve(address spender, uint256 amount) public virtual returns (bool) {
-       allowance[spender][msg.sender] = amount; 
+       allowance[msg.sender][spender] = amount;
        emit Approval(msg.sender, spender, amount);

        return true;
    }
```