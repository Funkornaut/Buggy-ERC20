## Summary
The `transferFrom` function in Challenge11 updates the wrong allowance mapping. This allows any approved spender to drain the approver's account regardless of the approved amount.

## Vulnerability Details
In the `transferFrom` function, the contract checks the correct allowance but updates the wrong mapping:
```solidity
function transferFrom(address from, address to, uint256 value) public returns (bool) {
    _transfer(from, to, value);
    uint256 currentAllowance = _allowances[from][msg.sender];
    require(currentAllowance >= value, "Insufficient allowance");
    _allowances[msg.sender][from] = currentAllowance - value; // WRONG: Indices are swapped
    return true;
}
```
The code decreases `_allowances[msg.sender][from]` instead of `_allowances[from][msg.sender]`, which means the spender's allowance never decreases.

## Impact
Once a user approves another address to spend any amount of tokens, that address can repeatedly transfer tokens until the approver's balance is drained completely. Users who believe they've granted limited access to their tokens are actually exposing their entire balance to theft.

## PoC
```solidity
vm.prank(alice);
challenge.approve(bob, 100);
assertEq(challenge.allowance(alice, bob), 100);

vm.prank(bob);
challenge.transferFrom(alice, bob, 100);
assertEq(challenge.balanceOf(bob), 100);
assertEq(challenge.allowance(alice, bob), 200); // bob's allowance should have been reduced by 100
assertEq(challenge.allowance(bob, alice), 100); // alice's allowance should have stayed the same
```

## Reccomendation
Fix the allowance update in `transferFrom` to use the correct indices and follow the Checks-Effects-Interactions pattern:
```diff
function transferFrom(address from, address to, uint256 value) public returns (bool) {
-   _transfer(from, to, value);
    uint256 currentAllowance = _allowances[from][msg.sender]; 
    require(currentAllowance >= value, "Insufficient allowance");
-   _allowances[msg.sender][from] = currentAllowance - value;
+   _allowances[from][msg.sender] = currentAllowance - value;
+   _transfer(from, to, value);
    return true;
}
```