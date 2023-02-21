//SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <=0.9.0;

contract Wallet {
    address[] public owners;
    uint limit;

    struct Transfer {
        uint amount;
        address payable receiver;
        uint approvals;
        bool hasBeenSent;
        uint id;
    }

    Transfer[] transferRequests;
    mapping(address => mapping(uint => bool)) approvals;

    event TransferRequestCreated(
        uint _id,
        uint _amount,
        address _initiater,
        address receiver
    );
    event ApprovalReceived(uint _id, uint _approvals, address receiver);
    event TransferApproved(uint _id);

    constructor(address[] memory _owners, uint _limit) {
        owners = _owners;
        limit = _limit;
    }

    modifier onlyOwners() {
        bool owner = false;
        for (uint i = 0; i <= owners.length; i++) {
            if (owners[i] == msg.sender) {
                owner = true;
            }
        }
        require(owner == true);
        _;
    }

    function deposit() public payable {}

    function createTransfer(
        uint _amount,
        address payable _receiver
    ) public onlyOwners {
        emit TransferRequestCreated(
            transferRequests.length,
            _amount,
            msg.sender,
            _receiver
        );
        transferRequests.push(
            Transfer(_amount, _receiver, 0, false, transferRequests.length)
        );
    }

    function approve(uint _id) public onlyOwners {
        require(transferRequests[_id].hasBeenSent == false);
        require(approvals[msg.sender][_id] == false, "You already voted");

        approvals[msg.sender][_id] = true;
        transferRequests[_id].approvals++;

        emit ApprovalReceived(
            transferRequests.length,
            transferRequests[_id].approvals,
            msg.sender
        );

        if (transferRequests[_id].approvals >= limit) {
            transferRequests[_id].hasBeenSent = true;
            transferRequests[_id].receiver.transfer(
                transferRequests[_id].amount
            );
        }

        emit TransferApproved(_id);
    }

    function getTranscationRequest() public view returns (Transfer[] memory) {
        return transferRequests;
    }

    function getBalance() public view returns (uint) {
        return address(this).balance;
    }
}

// ["0x5B38Da6a701c568545dCfcB03FcB875f56beddC4","0xAb8483F64d9C6d1EcF9b849Ae677dD3315835cb2","0x4B20993Bc481177ec7E8f571ceCaE8A9e22C02db"]
