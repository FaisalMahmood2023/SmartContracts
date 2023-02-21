//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "./Ownerable1.sol";

contract CrowdFunding is Ownerable {
    function deposit() public payable {
        require(msg.value >= minimumContribution, "You send less than ammount");
        require(block.timestamp < deadline, "Deadline has Passed");

        if (funder[msg.sender] == 0) {
            noOfFunder++;
            funders.push(msg.sender);
        }
        funder[msg.sender] += msg.value;
        raisedAmount += msg.value;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }

    function refund() public payable {
        require(
            block.timestamp > deadline && raisedAmount < target,
            "You are not Eligible for refund"
        );
        require(funder[msg.sender] > 0, "You are not deposit any ether");

        payable(msg.sender).transfer(funder[msg.sender]);
        funder[msg.sender] = 0;
        raisedAmount = address(this).balance;
        noOfFunder--;
    }

    struct Request {
        string description;
        address payable recipient;
        uint value;
        bool completed;
        uint noOfVoters;
        mapping(address => bool) voters;
    }

    mapping(uint => Request) public requests;
    uint public numOfRequests;

    function createRequests(
        string memory _description,
        address payable _recipient,
        uint _value
    ) public onlyOwner {
        Request storage newRequest = requests[numOfRequests];
        numOfRequests++;
        newRequest.description = _description;
        newRequest.recipient = _recipient;
        newRequest.value = _value;
        newRequest.completed = false;
        newRequest.noOfVoters = 0;
    }

    function voteRequest(uint _requestNo) public {
        require(funder[msg.sender] > 0, "You must be funder");
        Request storage thisRequest = requests[_requestNo];
        require(thisRequest.voters[msg.sender] == false, "You already voted");
        thisRequest.voters[msg.sender] = true;
        thisRequest.noOfVoters++;
    }

    function makePayment(uint _requestNo) public onlyOwner {
        require(raisedAmount >= target);
        Request storage thisRequest = requests[_requestNo];
        require(
            thisRequest.completed == false,
            "The Request has been completed"
        );
        require(
            thisRequest.noOfVoters > noOfFunder / 2,
            "Majority do not support"
        );
        thisRequest.recipient.transfer(thisRequest.value);
        thisRequest.completed = true;
    }
}
