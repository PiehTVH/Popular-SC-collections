// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.0;

contract ContractB {
    address public contractAAddress;
    uint256 public data;

    function setContractAAddress(address _address) public {
        contractAAddress = _address;
    }

    function delegateCallToContractA(uint256 _data) public {
        (bool success, ) = contractAAddress.delegatecall(
            abi.encodeWithSignature("setData(uint256)", _data)
        );
        require(success, "Delegate call function");
    }
}
