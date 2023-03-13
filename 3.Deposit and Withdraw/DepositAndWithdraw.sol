//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract DepositAndWithdraw {
    mapping(address => uint256) public balance;

    event Deposit(address Depositer, uint256 DepositAmount);
    event Withdraw(address Withdrawer, uint256 WithdrawAmount);

    function deposit() public payable returns (uint256) {
        balance[msg.sender] += msg.value;

        emit Deposit(msg.sender, msg.value);

        return balance[msg.sender];
    }

    function withdraw(uint256 amount) public returns (uint256) {
        require(balance[msg.sender] >= amount, "You have enough Balance");
        payable(msg.sender).transfer(amount);
        balance[msg.sender] -= amount;

        emit Withdraw(msg.sender, amount);

        return balance[msg.sender];
    }
}
