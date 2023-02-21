//SPDX-License-Identifier: GPL-3.0

pragma solidity >=0.5.0 <0.9.0;

contract Quiz {
    address public manager;
    uint public amount;
    uint public deadline;
    uint public noOfQuiz;

    constructor() {
        manager = msg.sender;
        amount = 10e18;
        deadline = block.timestamp + 3600;
        noOfQuiz = 4;
    }

    receive() external payable {
        require(msg.value == amount, "You Send Less Amount");
        require(manager == msg.sender, "You are not the Manager");
    }

    address payable[] participant;
    mapping(address => uint) public participantCorrectQuiz;
    uint public noOfAttemptQuiz;
    uint public noOfParticipants;

    struct Participant {
        address participantAddress;
        uint totalQuiz;
        uint correctQuiz;
        uint winningAmmount;
        bool amountDistributed;
    }

    mapping(uint => Participant) public participantsInformation;

    function QuizWinner(uint _correctQuiz) public {
        require(
            noOfQuiz >= _correctQuiz,
            "Your Correct Quiz is greater than the no. of Quiz"
        );
        require(
            manager != msg.sender,
            "You cannot Participant in the quiz because you are the manager"
        );
        require(
            participantCorrectQuiz[msg.sender] == 0,
            "You cannot Participant the Quiz because You taken the Quiz"
        );
        require(
            block.timestamp < deadline,
            "You cannot Particpantthe Quiz becuase Deadline has Passed "
        );
        require(noOfQuiz / 2 <= _correctQuiz, "You are not winner");
        noOfAttemptQuiz += _correctQuiz;
        participant.push(payable(msg.sender));
        participantCorrectQuiz[msg.sender] += _correctQuiz;

        Participant
            storage completeDetailsOfParticipants = participantsInformation[
                noOfParticipants
            ];
        noOfParticipants++;
        completeDetailsOfParticipants.participantAddress = msg.sender;
        completeDetailsOfParticipants.totalQuiz = noOfQuiz;
        completeDetailsOfParticipants.correctQuiz = participantCorrectQuiz[
            msg.sender
        ];
        completeDetailsOfParticipants.amountDistributed = false;
    }

    function allParticipants() public view returns (address payable[] memory) {
        return participant;
    }

    function makeQuizReward() public {
        require(block.timestamp > deadline, "Quiz is running");
        require(manager == msg.sender, "You are not the Manager");
        require(participant.length == noOfParticipants, "");
        for (uint i = 0; i < participant.length; i++) {
            // participant[i];
            Participant storage DistributedAmount = participantsInformation[i];
            require(
                DistributedAmount.amountDistributed == false,
                "The amount has been transfered"
            );
            DistributedAmount.winningAmmount =
                (amount / noOfAttemptQuiz) *
                participantCorrectQuiz[participant[i]];
            payable(DistributedAmount.participantAddress).transfer(
                DistributedAmount.winningAmmount
            );
            DistributedAmount.amountDistributed = true;
        }
    }
}
