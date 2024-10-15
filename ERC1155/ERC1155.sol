// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MyNFT {
    mapping(address => mapping(address => bool)) private _operatorApprovals;
    mapping(uint256 => mapping(address => uint256)) private _balances; // token type -> owner -> amount
    mapping(uint256 => address) private _creators;

    event TransferSingle(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256 id,
        uint256 amount
    );
    event TransferBatch(
        address indexed operator,
        address indexed from,
        address indexed to,
        uint256[] ids,
        uint256[] amounts
    );
    event ApprovalForAll(
        address indexed owner,
        address indexed operator,
        bool approved
    );
    event URI(string value, uint256 indexed id);

    function balanceOf(
        address owner,
        uint256 id
    ) public view returns (uint256) {
        return _balances[id][owner];
    }

    function balanceOfBatch(
        address[] memory owners,
        uint256[] memory ids
    ) public view returns (uint256[] memory) {
        uint256[] memory balances = new uint256[](owners.length);
        for (uint256 i; i < owners.length; ) {
            balances[i] = _balances[ids[i]][owners[i]];

            unchecked {
                ++i;
            }
        }
        return balances;
    }

    function setApprovalForAll(address operator, bool approved) public {
        require(operator != msg.sender, "Invalid operator");

        _operatorApprovals[msg.sender][operator] = approved;
        emit ApprovalForAll(msg.sender, operator, approved);
    }

    function isApprovedForAll(
        address owner,
        address operator
    ) public view returns (bool) {
        return _operatorApprovals[owner][operator];
    }

    function safeTransferFrom(
        address from,
        address to,
        uint256 id,
        uint256 amount,
        bytes memory
    ) public {
        // id: The unique identifier of the token being transferred.
        require(to != msg.sender, "Invalid address");

        require(
            from == msg.sender || isApprovedForAll(from, msg.sender),
            "Transfer not authorized"
        );

        require(balanceOf(from, id) >= amount, "Insufficient balance");

        _balances[id][from] -= amount;
        _balances[id][to] += amount;

        emit TransferSingle(msg.sender, from, to, id, amount);
    }

    function safeBatchTransferFrom(
        address from,
        address to,
        uint256[] memory ids,
        uint256[] memory amounts,
        bytes memory
    ) public {
        require(ids.length == amounts.length, "Array length mismatch");
        require(to != address(0), "Invalid address");
        require(
            from == msg.sender || isApprovedForAll(from, msg.sender),
            "Transfer not authorized"
        );

        for (uint256 i; i < ids.length; ) {
            uint256 id = ids[i];
            uint256 amount = amounts[i];
            require(balanceOf(from, id) >= amount, "Insufficient balance");

            _balances[id][from] -= amount;
            _balances[id][to] += amount;

            unchecked {
                ++i;
            }
        }

        emit TransferBatch(msg.sender, from, to, ids, amounts);
    }

    function mint(address to, uint256 id, uint256 amount) public {
        require(to != address(0), "Invalid address");
        require(_creators[id] == address(0), "Token already minted");

        _balances[id][to] += amount;
        _creators[id] = msg.sender;

        emit TransferSingle(msg.sender, address(0), to, id, amount);
    }

    function setURI(string memory uri, uint256 id) public {
        require(_creators[id] == msg.sender, "Only creator can set URI");

        emit URI(uri, id);
    }
}
