## Summary
A mistake in the `onlyOwner` modifier sets the `msg.sender` to the owner instead of checking if the `msg.sender` is the `owner`. 

## Vulnerability Details
```solidity
modifier onlyOwner() {
        msg.sender == owner;
        _;
    }
```
## Impact
This renders the modifier useless and allows anyone to `mint` and `burn` tokens.

## PoC
```solidity
 function test_Mint(address _minter) public {
        vm.assume(_minter != address(this) && _minter != address(0));

        vm.prank(_minter);
        challenge.mint(_minter, 69);
        assertEq(challenge.balanceOf(_minter), 69);
    }
```

## Reccomendation
Check the `msg.sender` against the `owner` address in the modifier
```diff
modifier onlyOwner() {
-        msg.sender == owner;
+       if (msg.sender) != owner revert OnlyOwner(); 
        _;
    }
```