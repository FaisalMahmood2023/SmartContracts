//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Fund {
    address payable[] public funders;
    mapping(address => uint) public fundersAmount;

    receive() external payable {}

    function transfer() external payable {
        funders.push(payable(msg.sender));
        fundersAmount[msg.sender] = msg.value;
    }

    function withdraw(uint amount) external {
        require(amount <= 1 ether, "You cannot witddraw more than 1 Ether");
        payable(msg.sender).transfer(amount);
        fundersAmount[msg.sender] -= amount;
    }
}
