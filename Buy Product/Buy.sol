// SPDX-License-Identifier: UNLICENSED
pragma solidity >=0.5.0 <0.9.0;

contract Buy {
    address payable owner;

    constructor() {
        owner = payable(msg.sender);
    }

    struct Memo {
        string name;
        string message;
        uint256 timestamp;
        address from;
    }

    Memo[] memoes;

    function buyProduct(
        string memory name,
        string memory message
    ) public payable {
        require(msg.value > 0, "Please pay greater than Zero");
        owner.transfer(msg.value);
        memoes.push(Memo(name, message, block.timestamp, msg.sender));
    }

    function getMemoes() public view returns (Memo[] memory) {
        return memoes;
    }
}
