//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

interface FGTokenIERC20 {
    function balanceOf(address account) external view returns (uint256);

    function transfer(address to, uint256 amount) external returns (bool);

    event Transfer(address indexed from, address indexed to, uint256 value);
}

contract Faucet {
    address payable public owner;
    FGTokenIERC20 public token;

    uint256 public withdrawAmount = 10 * (10 ** 18);

    uint256 public locktime = 1 minutes;
    mapping(address => uint256) public nextAccessTime;

    event Withdrawal(address indexed to, uint256 indexed amount);
    event Deposit(address indexed from, uint256 indexed amount);

    constructor(address FGTokenAddress) {
        token = FGTokenIERC20(FGTokenAddress);
        owner = payable(msg.sender);
    }

    modifier onlyOwner() {
        require(
            owner == msg.sender,
            "Only the contract owner can call this function"
        );
        _;
    }

    function requestTokens() public {
        require(
            msg.sender != address(0),
            "Request must not originate from a zero account"
        );
        require(
            token.balanceOf(address(this)) >= withdrawAmount,
            "Insufficient balance in faucet for withdrawal request"
        );
        require(
            block.timestamp >= nextAccessTime[msg.sender],
            "Insufficient time elapsed since last withdrawal - try again later."
        );
        nextAccessTime[msg.sender] = block.timestamp + locktime;
        token.transfer(msg.sender, withdrawAmount);
    }

    receive() external payable {
        emit Deposit(msg.sender, msg.value);
    }

    function getBalance() external view returns (uint256) {
        return token.balanceOf(address(this));
    }

    function setWithdrawAmount(uint256 amount) public onlyOwner {
        withdrawAmount = amount * (10 ** 18);
    }

    function setLockTime(uint amount) public onlyOwner {
        locktime = amount * 1 minutes;
    }

    function withdraw() external onlyOwner {
        emit Withdrawal(msg.sender, token.balanceOf(address(this)));
        token.transfer(msg.sender, token.balanceOf(address(this)));
    }
}
