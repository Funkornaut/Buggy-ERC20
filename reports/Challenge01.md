## Summary
The Challenge01 contract is an ERC-20 token implementation with three critical issues:
1. The `_transfer` function fails to decrement the sender's balance, allowing unlimited token transfers
2. The `_mint` function is internal but not virtual, preventing inheritance and proper implementation
3. The `_burn` function is internal but not virtual, preventing inheritance and proper implementation

## Vulnerability Details

### 1. Transfer Never Decrements Sender Balance
In the `_transfer` function, the sender's balance is checked but never decremented after the transfer:
```solidity
uint256 fromBalance = _balances[from];
if (fromBalance < value) revert InsufficientBalance(from, fromBalance, value);

_balances[to] += value;
emit Transfer(from, to, value);
```
The balance check is conducted, yet `_balances[from]` is not decremented by the amount transferred. This results in improper accounting, allowing users to transfer more tokens than they genuinely possess.

### 2. Non-Virtual _mint Function
The `_mint` function is marked as internal but not virtual:
```solidity
function _mint(address account, uint256 value) internal {
```
This prevents child contracts from overriding the minting logic, which is a common requirement for ERC-20 implementations. The function should be marked as `virtual` to allow proper inheritance and customization.

### 3. Non-Virtual _burn Function
Similar to the `_mint` function, the `_burn` function is internal but not virtual:
```solidity
function _burn(address account, uint256 value) internal {
```
This prevents child contracts from overriding the burning logic, which is also a common requirement for ERC-20 implementations. The function should be marked as `virtual` to allow proper inheritance and customization.

## Impact

### 1. Transfer Never Decrements Sender Balance
This is a significant vulnerability that fundamentally undermines the economic integrity of the token. Users are able to transfer an unrestricted quantity of tokens without legitimate ownership.

### 2. Non-Virtual _mint Function
This design flaw prevents proper inheritance and customization of the minting logic, limiting the contract's flexibility and potential use cases. While not a direct security vulnerability, it significantly reduces the contract's utility and maintainability.

### 3. Non-Virtual _burn Function
Similar to the `_mint` issue, this prevents proper inheritance and customization of the burning logic, limiting the contract's flexibility and potential use cases.

## PoC

### 1. Transfer Never Decrements Sender Balance
```solidity
function test_transferNeverDecrements_from_balance() public {
    vm.prank(alice);
    challenge.transfer(bob, 100);
    assertEq(challenge.balanceOf(alice), 900); // Fails - balance is still 1000
    assertEq(challenge.balanceOf(bob), 1100);
}
```
The test demonstrates that Alice's balance remains at 1000 after transferring 100 tokens to Bob, while Bob's balance correctly increases to 1100.

## Reccomendation

### 1. Transfer Never Decrements Sender Balance
Add the balance decrement in the `_transfer` function:
```solidity
function _transfer(address from, address to, uint256 value) internal {
    if (from == address(0)) revert InvalidSender(from);
    if (to == address(0)) revert InvalidReceiver(to);

    uint256 fromBalance = _balances[from];
    if (fromBalance < value) revert InsufficientBalance(from, fromBalance, value);

    _balances[from] = fromBalance - value;
    _balances[to] += value;
    emit Transfer(from, to, value);
}
```

### 2. Non-Virtual _mint Function
Make the `_mint` function virtual:
```solidity
function _mint(address account, uint256 value) internal virtual {
```

### 3. Non-Virtual _burn Function
Make the `_burn` function virtual:
```solidity
function _burn(address account, uint256 value) internal virtual {
```