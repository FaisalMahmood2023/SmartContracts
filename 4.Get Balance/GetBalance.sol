//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract GetBalance {
    mapping(address => uint256) public balance;

    function deposit() public payable returns (uint256) {
        balance[msg.sender] += msg.value;

        return balance[msg.sender];
    }

    function withdraw(uint256 amount) public returns (uint256) {
        require(balance[msg.sender] >= amount, "You have enough Balance");
        payable(msg.sender).transfer(amount);
        balance[msg.sender] -= amount;

        return balance[msg.sender];
    }

    //check the balance of a Contract
    function getBalanceContract() public view returns (uint256) {
        return address(this).balance;
    }

    // check the balance of a given address
    function getBalanceAddress(address addr) public view returns (uint256) {
        return addr.balance;
    }

    // check the balance of a given address------contract
    function getBalance(address addr) public view returns (uint256) {
        return balance[addr];
    }
}
