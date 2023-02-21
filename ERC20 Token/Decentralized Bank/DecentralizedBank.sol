//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "./FGToken.sol";

contract DecentralizedBank {
    FGToken private token;
    mapping(address => uint256) public balance;
    mapping(address => uint256) public depositStart;

    mapping(address => bool) public isDeposit;
    mapping(address => bool) public isBorrow;

    event Deposit(address indexed user, uint256 amount, uint256 DepositTime);

    event Withdraw(
        address indexed user,
        uint256 amount,
        uint256 depositTime,
        uint256 interest
    );

    event Borrow(
        address indexed user,
        uint256 amount,
        uint256 borrowTokenAmount
    );

    event Payoff(address indexed user, uint256 fee);

    receive() external payable {}

    function deposit() public payable {
        require(isDeposit[msg.sender] == false, "Already Deposit");
        require(msg.value == 0.01 ether, "Deposit 1 or more Ether");

        balance[msg.sender] += msg.value;
        depositStart[msg.sender] += block.timestamp;
        isDeposit[msg.sender] = true;

        emit Deposit(msg.sender, msg.value, block.timestamp);
    }

    function withdraw() public {
        require(isDeposit[msg.sender] == true, "No Deposit");
        require(balance[msg.sender] == 1e16, "You have Enough Balance");

        uint256 userBalance = balance[msg.sender];
        uint256 depositTimePerSecond = block.timestamp -
            depositStart[msg.sender];

        uint256 minDeposit = 1 * (10 ** 16); //1 ETH
        uint256 APY = 10000; //10000%

        uint256 calc = (minDeposit * (APY / 100)) / depositTimePerSecond;

        uint256 interestPerSecond = calc * (balance[msg.sender] / minDeposit);
        uint256 interest = interestPerSecond * depositTimePerSecond;

        payable(msg.sender).transfer(userBalance);
        token.minting(msg.sender, interest);

        balance[msg.sender] = 0;
        isDeposit[msg.sender] = false;
        depositStart[msg.sender] = 0;

        emit Withdraw(msg.sender, userBalance, depositTimePerSecond, interest);
    }

    function borrow() public payable {
        require(msg.value == 1e16, "must equal or greater than 0.01 ETH");
        require(isBorrow[msg.sender] == false, "Already Loan Taken");

        balance[msg.sender] += msg.value;

        uint256 tokensMint = balance[msg.sender] / 2; //50% --> token amount to mint

        token.minting(msg.sender, tokensMint);

        isBorrow[msg.sender] = true;

        emit Borrow(msg.sender, balance[msg.sender], tokensMint);
    }

    function payOff() public {
        require(isBorrow[msg.sender] == true, "Loan not Active");
        require(
            token.transferFrom(
                msg.sender,
                address(this),
                balance[msg.sender] / 2
            ),
            "Cannot Recieve Token"
        ); //must approve DBank 1st

        uint256 fee = 10; //10% fee
        uint256 calcFee = balance[msg.sender] / fee;

        payable(msg.sender).transfer(balance[msg.sender] - calcFee);

        balance[msg.sender] = 0;
        isBorrow[msg.sender] = false;

        emit Payoff(msg.sender, calcFee);
    }
}
