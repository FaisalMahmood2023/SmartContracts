// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Ownerable {
    address public owner;

    constructor() {
        owner = msg.sender;
    }
}
