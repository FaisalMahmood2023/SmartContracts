// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <=0.9.0;

contract Ownerable {
    address manager;

    modifier onlyOwner() {
        require(manager == msg.sender, "You are not the Manager");
        _;
    }

    constructor() {
        manager = msg.sender;
    }

    function getOwner() internal view returns (address) {
        return manager;
    }
}
