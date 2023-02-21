//SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0 <0.9.0;

contract Ownerable {
    address public owner;
    address[] public funders; 
    uint public noOfFunder;
    uint target = 10e18;
    uint deadline = block.timestamp + 60;
    uint minimumContribution = 2e18;
    uint public raisedAmount;

    mapping(address => uint) public funder;

    modifier onlyOwner() {
        require(owner == msg.sender, "You are not the owner");
        _;
    }

    constructor(){
        owner = msg.sender;
    }
    
}