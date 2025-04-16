## Summary
Challenge16 contains a critical vulnerability in the `approve` function where it emits an approval event but doesn't actually update the allowance mapping, making it impossible for users to use `transferFrom`.

## Vulnerability Details
The approve function doesn't modify any state - it only emits an event:
```solidity
function approve(address spender, uint256 value) public returns (bool) {
    emit Approval(msg.sender, spender, value);
    return true;
}
```
This function completely fails to update the _allowances mapping, despite having a correctly implemented internal _approve function that does update the state. The missing allowance update means that even after a successful "approve" call that emits the correct event, the actual allowance remains at 0.

## Impact
Approvals can never be set and `transferFrom` is broken because of it.

## PoC
See Challenge16.t.sol

## Reccomendation
Modify the approve function to call the internal _approve function:
```diff
function approve(address spender, uint256 value) public returns (bool) {
+       _approve(msg.sender, spender, value);
        emit Approval(msg.sender, spender, value);
        return true;
    }
```