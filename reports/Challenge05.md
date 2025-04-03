## Summary
There is a critical vulnerability in the `transferFrom` function of the Challenge05 contract where the `from` and `to` parameters are swapped in the internal `_transfer` call. This causes tokens to flow in the opposite direction than intended, resulting in users being able to steal tokens from other users who have approved them for transfers.

## Vulnerability Details
In the `transferFrom` function on line 62, the parameters passed to the `_transfer` function are in the wrong order:

```solidity
function transferFrom(address from, address to, uint256 value) public returns (bool) {
    _spendAllowance(from, msg.sender, value);
    _transfer(to, from, value); // INCORRECT: Parameters are swapped
    return true;
}
```

The correct implementation should be:
```solidity
_transfer(from, to, value);
```

This parameter swap causes tokens to flow from the `to` address to the `from` address, which is the opposite of the intended direction. The vulnerability is particularly severe because the `_spendAllowance` function correctly decreases the allowance for the caller to spend tokens on behalf of the `from` address, making the transaction appear valid at first glance.

## Impact
This vulnerability has the following impacts:

1. **Token Theft**: Any user who receives an approval from another user can steal tokens from themselves to the approver (which due to the bug will actually transfer tokens from the approver to themselves).

2. **Broken ERC-20 Compatibility**: This bug breaks ERC-20 compatibility, as the `transferFrom` function does not behave as expected by third-party applications and integrations.


This is a High severity vulnerability as it directly leads to loss of user funds.

## PoC
See test/Challenge05.t.sol

## Recommendation
Correct the parameter order in the `transferFrom` function:

```solidity
function transferFrom(address from, address to, uint256 value) public returns (bool) {
    _spendAllowance(from, msg.sender, value);
    _transfer(from, to, value); // FIXED: Parameters in correct order
    return true;
}
```

Additionally, it is recommended to:
1. Add comprehensive test cases to verify the correct behavior of all token transfer functions
2. Consider implementing a formal verification process for critical functions
3. Conduct thorough code reviews and audits before deployment to production