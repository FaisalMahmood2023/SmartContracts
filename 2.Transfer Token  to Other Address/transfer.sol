//SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0 <0.9.0;

contract TransferTokens {
    uint256 token;
    mapping(address=>uint256) public balance;

    event Transfer(address from, address to, uint256 amount);

    constructor(uint256 _token){
        token = _token;
        balance[msg.sender] = _token;
    }

    //Solidity function to transfer tokens from one address to another
    function transfer(address to, uint256 amount) public {
        require(amount > 0, "Amount must be greator than Zero");
        require(to != address(0), "Invalid Recipient Address");
        require(balance[msg.sender] >= amount, "Insufficient Balance");
        require(msg.sender != to, "Sender is not equal to the Recipient");

        balance[msg.sender] -= amount;
        balance[to] += amount;

        emit Transfer(msg.sender, to, amount);
    }
}

