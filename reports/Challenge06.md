## Summary
The Challenge06 contract implements an ERC-20 token with a blacklist feature designed to restrict specific addresses from transferring tokens. However, there is a critical vulnerability that allows blacklisted users to completely bypass these restrictions by using a second wallet.

## Vulnerability Details
There are two key issues that, when combined, render the blacklist functionality completely ineffective:

1. **Missing blacklist check in `approve` function**: Blacklisted addresses can still call `approve()` since it has no blacklist verification:
```solidity
function approve(address spender, uint256 value) public returns (bool) {
    _approve(msg.sender, spender, value);
    return true;
}
```

2. **Incomplete blacklist check in `transferFrom` function**: The `transferFrom` function only checks if the spender (`msg.sender`) and recipient (`to`) are blacklisted, but not the owner of the tokens (`from`):
```solidity
function transferFrom(address from, address to, uint256 value) public returns (bool) {
    require(!blacklist[msg.sender] && !blacklist[to], "Sender or receiver blacklisted");
    _spendAllowance(from, msg.sender, value);
    _transfer(from, to, value);
    return true;
}
```

This combination creates a complete bypass: a blacklisted address can approve a second, non-blacklisted wallet to spend its tokens, and that second wallet can transfer tokens out of the blacklisted address.

## Impact
This vulnerability completely undermines the blacklist system:

1. **Complete blacklist bypass**: Any blacklisted user can create a new wallet, approve it to spend tokens, and move all their assets despite being blacklisted.

2. **Regulatory compliance failure**: If the contract is used for compliance with regulations or sanctions, this vulnerability would allow sanctioned entities to continue moving assets.

This is a High severity vulnerability as it completely defeats the core security feature of the contract.

## PoC
See test/Challenge06.t.sol

## Recommendation
1. Add blacklist checks to the `approve` function:
```solidity
function approve(address spender, uint256 value) public returns (bool) {
    require(!blacklist[msg.sender] && !blacklist[spender], 
            "Approver or spender blacklisted");
    _approve(msg.sender, spender, value);
    return true;
}
```

2. Include the `from` address in the blacklist check for `transferFrom`:
```solidity
function transferFrom(address from, address to, uint256 value) public returns (bool) {
    require(!blacklist[msg.sender] && !blacklist[from] && !blacklist[to], 
            "One of the addresses is blacklisted");
    _spendAllowance(from, msg.sender, value);
    _transfer(from, to, value);
    return true;
}
```

3. Consider revoking all existing approvals when an address is blacklisted to prevent any approvals granted before blacklisting from being exploited.