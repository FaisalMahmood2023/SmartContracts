//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Ownerable {
    address public owner;

    modifier onlyOwner() {
        require(owner == msg.sender, "You are not owner");
        _;
    }

    constructor() {
        owner = msg.sender;
    }
}
