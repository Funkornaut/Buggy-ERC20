## Summary
The `transferFrom` function in Challenge14 contains a critical logic error where token allowances are only decremented when set to the maximum possible value (type(uint256).max), allowing unlimited token transfers for any other allowance value.

## Vulnerability Details
In the transferFrom function, the condition for decrementing allowance is backwards:
```solidity
function transferFrom(address from, address to, uint256 amount) public virtual returns (bool) {
    uint256 allowed = allowance[from][msg.sender];

    if (allowed == type(uint256).max) allowance[from][msg.sender] = allowed - amount; 
    // ^ INCORRECT: Only decrements when allowance is maxed out

    balanceOf[from] -= amount;
    // ... rest of function
}
```
Standard ERC-20 implementation should either:
1. Decrement allowance for all values (old approach)
2. Decrement allowance for all values EXCEPT max (modern infinite approval)

## Impact
This vulnerability allows any user to:
1. Receive an approval for any non-maximum amount (e.g., 50 tokens)
2. Transfer that amount repeatedly without the allowance ever decreasing
3. Drain the approver's entire account despite only having approval for a limited amount

## PoC
See Challenge14.t.sol

## Reccomendation
Reverse the condition for decrementing allowance:
```solidity
function transferFrom(address from, address to, uint256 amount) public virtual returns (bool) {
    uint256 allowed = allowance[from][msg.sender];

    if (allowed != type(uint256).max) allowance[from][msg.sender] = allowed - amount;
    // ^ FIXED: Only skip decrementing for max value (infinite approval)
    
    // ... rest of function
}
```