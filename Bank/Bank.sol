// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <=0.9.0;

import "./Ownerable.sol";
import "./Destroyable.sol";

// import "./Government.sol";

interface GovtInterface {
    function addTranscation(address _from, address _to, uint amount) external;
}

contract Bank is Ownerable, Destroyable {
    GovtInterface govtInstance =
        GovtInterface(0xdDb68Efa4Fdc889cca414C0a7AcAd3C5Cc08A8C5);

    mapping(address => uint) public balance;

    event balanceAdded(uint amount, address depositTo);
    event Transfer(address sender, address receiver, uint amount);

    // function addBalance(uint _add) public returns(uint){
    //     balance[msg.sender] += _add;
    //     emit  balanceAdded(_add, msg.sender);
    //     return balance[msg.sender];
    // }

    function deposit() public payable returns (uint) {
        balance[msg.sender] += msg.value;
        emit balanceAdded(msg.value, msg.sender);
        return balance[msg.sender];
    }

    function withdraw(uint amount) public returns (uint) {
        require(balance[msg.sender] >= amount, "You have enough Balance");
        // uint balanceTransfer = balance[msg.sender];
        payable(msg.sender).transfer(amount);
        balance[msg.sender] -= amount;
        return balance[msg.sender];
        // balance[msg.sender] = 0;
    }

    // function getBalance() public view onlyOwner returns(uint){
    //     return balance[msg.sender];
    // }

    function getBalance() public view onlyOwner returns (uint) {
        return address(this).balance;
    }

    function transfer(address receiver, uint amount) public {
        require(
            balance[msg.sender] >= amount,
            "You have not enough balance to send"
        );
        require(msg.sender != receiver, "You are the owner");

        uint preBalance = balance[msg.sender];

        balance[msg.sender] -= amount;
        balance[receiver] += amount;

        emit Transfer(msg.sender, receiver, amount);

        govtInstance.addTranscation(msg.sender, receiver, amount);

        assert(preBalance == balance[msg.sender] + amount);
    }
}
