## Summary
The `Challenge07` contract has an unprotected `mint` function that allows any user to create an unlimited amount of tokens.

## Vulnerability Details
The `mint` function is public with no access controls:

```solidity
function mint(address to, uint256 value) public {
    _mint(to, value);
}
```

Any address can call this function and mint an arbitrary amount of tokens to any address.

## Impact
This vulnerability has significant implications:

1. Token inflation - Anyone can create unlimited tokens, potentially decreasing the value of existing tokens.
2. Market manipulation - Attackers could mint large amounts of tokens, affecting market dynamics.
3. Disruption of token economics - There is a lack of control over the total supply.

## PoC
```solidity
function testUnprotectedMint() public {
    // Attacker starts with 0 tokens
    assertEq(challenge.balanceOf(attacker), 0);
    
    // Attacker mints 100 million tokens to themselves
    vm.prank(attacker);
    challenge.mint(attacker, 100_000_000 * 10**18);
    
    // Attacker now has 100 million tokens
    assertEq(challenge.balanceOf(attacker), 100_000_000 * 10**18);
}
```

## Recommendation
Add the `onlyOwner` modifier to the `mint` function:

```solidity
function mint(address to, uint256 value) public onlyOwner {
    _mint(to, value);
}
```

This restricts minting capabilities to the contract owner only, which is the standard pattern for mintable tokens.