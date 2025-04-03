## Summary
The ERC-20 token contract contains a critical vulnerability that allows any user to burn tokens from any other account without authorization.

## Vulnerability Details
The vulnerability exists in the `burn` function implementation:

```solidity
function burn(address account, uint256 value) public {
    require(account != address(0), "Invalid burner");
    uint256 accountBalance = _balances[account];
    require(accountBalance >= value, "Insufficient balance");

    _balances[account] = accountBalance - value;
    _totalSupply -= value;
    emit Transfer(account, address(0), value);
}
```

The function allows any address to burn tokens from any account without requiring permission or ownership. It only checks that the account isn't the zero address and has sufficient balance, but doesn't verify that the caller has authority to burn those tokens.

## Impact
Critical:
- Any user can burn tokens from any other user's account without permission

## PoC
The test demonstrates the vulnerability:

```solidity
function test_Burn(uint256 _amount) public {
    _amount = bound(_amount, 0, challenge.balanceOf(alice));

    uint256 aliceBalanceBeforeBurn = challenge.balanceOf(alice);
    uint256 totalSupplyBeforeBurn = challenge.totalSupply();
    
    vm.prank(bob);
    challenge.burn(alice, _amount);

    assertEq(challenge.balanceOf(alice), aliceBalanceBeforeBurn - _amount);
    assertEq(challenge.totalSupply(), totalSupplyBeforeBurn - _amount);
}
```

This test confirms that Bob can successfully burn tokens from Alice's account without her permission.

## Recommendation
Modify the burn function to only allow users to burn their own tokens or require explicit approval:

```solidity
function burn(uint256 value) public {
    _burn(msg.sender, value);
}

function burnFrom(address account, uint256 value) public {
    _spendAllowance(account, msg.sender, value);
    _burn(account, value);
}

function _burn(address account, uint256 value) internal {
    require(account != address(0), "Invalid burner");
    uint256 accountBalance = _balances[account];
    require(accountBalance >= value, "Insufficient balance");

    _balances[account] = accountBalance - value;
    _totalSupply -= value;
    emit Transfer(account, address(0), value);
}
```