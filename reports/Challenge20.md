## Summary
A critical vulnerability exists in the `transferFrom` function of the Challenge20 ERC-20 contract where the allowance is incorrectly increased instead of decreased when tokens are transferred, leading to unlimited spending of an account's tokens by an approved spender.

## Vulnerability Details
In the `transferFrom` function, line 66, the allowance is incorrectly modified:
```solidity
if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed + amount;
```

The operation adds the transferred amount to the allowance instead of subtracting it. This breaks the core security feature of ERC-20 tokens where allowances limit how many tokens a spender can transfer from another account.

## Impact
This vulnerability allows any address with even a minimal allowance to drain the entire balance of the account that granted the allowance. For example:
1. Alice approves Bob to spend 10 tokens
2. Bob transfers 10 tokens, but now his allowance becomes 20 instead of 0
3. Bob can continue transferring more tokens, with his allowance increasing each time
4. Eventually, Bob can drain Alice's entire balance

This completely undermines the allowance mechanism and creates a severe security risk for all users of the token.

## PoC
A proof of concept is provided in the test file `Challenge20.t.sol`. The test `testAllowanceIncreaseVulnerability` demonstrates how an account with a small initial allowance can drain the entire balance of another account due to this vulnerability.

## Recommendation
Replace the incorrect allowance update logic with the correct subtraction:
```solidity
if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
```

This change ensures that the spender's allowance is properly decreased after each transfer, maintaining the expected security behavior of the ERC-20 standard.