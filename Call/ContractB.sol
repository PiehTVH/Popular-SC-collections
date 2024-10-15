// Contract B
pragma solidity ^0.8.0;

contract ContractB {
    address public contractAAddress;
    uint256 public data;

    function setContractAAddress(address _address) public {
        contractAAddress = _address;
    }

    function CallToContractA(uint256 _data) public payable {
        // Perform call to Contract A's setData function
        (bool success, ) = contractAAddress.call{value: msg.value}(
            abi.encodeWithSignature("setData(uint256)", _data)
        );
        require(success, "call failed");
    }

    function testCallDoesNotExist() public payable {
        (bool success, ) = contractAAddress.call{value: msg.value}(
            abi.encodeWithSignature("doesNotExist()")
        );
        require(success, "Test call failed");
    }
}
