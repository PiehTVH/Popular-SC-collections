# Delegatecall in Solidity

`delegatecall` is a low-level function that allows one contract to call another contract and run its code within the context of the calling contract. \* Commonly used in the context of `proxy contract` and `upgradeable` smart contracts.

    * Other calls: StaticCall, CallCode or Call

- **Call**: By directly calling from a contract through a function which will not set the caller's value but sets the callee's value. And the sender in this will be the caller only.

- **CallCode**: deprecated

- **StaticCall**: This is similar to `call`, but it does not allow the called contract to modify state or storage. It is mainly used to read data from other contracts without making any changes to the state.

- **DelegateCall**: When a third contract calls a delegate call to some function in callee on behalf of the caller and storage changes are made in the caller’s value and nothing is reflected in callee’s storage.

## How do DelegateCall works?

1. Contract A initiates a delegate call to Contract B, specifying which function to execute in Contract B.

2. During the delegate call, Contract B's code runs as if it were part of Contract A. This means Contract B can access and modify Contract A's storage.

3. After the delegate call is completed, Contract A's storage will be updated with any changes made by Contract B.

> **_Note_**: If Contract A utilises a delegate call to call a function from Contract B, the following two statements are true:
>
> 1. Contract A's state variables can be read and written.
> 2. Contract B's state variables are never read or written.
