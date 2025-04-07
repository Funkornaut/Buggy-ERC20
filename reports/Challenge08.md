## Summary
The Challenge08 contract has a critical flaw in the `burn` function where tokens are removed from user balances but the total supply is not decreased.

## Vulnerability Details
The burn function decreases the user's balance but doesn't update the total supply:
```solidity
function burn(uint256 value) public {
    _balances[msg.sender] -= value;
    emit Transfer(msg.sender, address(0), value);
}
```
It also lacks a balance check before the burn.

## Impact
Token Supply Inconsistency: The reported total supply will be higher than the actual circulating supply, leading to incorrect market cap calculations and token economics.

## PoC
```solidity
function test_BurnDoesNotDecreaseTotalSupply(uint256 _burnAmount) public {
        uint256 initialSupply = challenge.totalSupply();
        _burnAmount = bound(_burnAmount, 1, initialSupply);
        vm.prank(alice);
        challenge.burn(_burnAmount);
        // Total supply should have decreased by the burn amount but it doesn't
        assertEq(challenge.totalSupply(), initialSupply);
        // Alice's balance is decreased
        assertEq(challenge.balanceOf(alice), initialSupply - _burnAmount);
    }
```
## Reccomendation
Decrease the `totalSupply` when burning tokens
```solidity
function burn(uint256 value) public {
    _balances[msg.sender] -= value;
    _totalSupply -= value;
    emit Transfer(msg.sender, address(0), value);
}
```