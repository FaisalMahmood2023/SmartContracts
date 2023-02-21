//SPDX-License-Identifier: MIT
pragma solidity >=0.4.2 <0.9.0;

contract Funder {
    uint public numOffFunder;
    mapping(uint => address) private funders;

    receive() external payable {}

    function transfer() external payable {
        funders[numOffFunder] = msg.sender;
    }

    function withdraw(uint withdrawAmount) external {
        require(
            withdrawAmount <= 2 * 1e18,
            "Cannot withdraw more than 2 ether"
        );
        payable(msg.sender).transfer(withdrawAmount);
    }
}
