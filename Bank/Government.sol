// SPDX-License-Identifier: MIT
pragma solidity >0.5.0 <=0.9.0;

contract Government {
    struct Transcation {
        address from;
        address to;
        uint amount;
        uint txId;
    }

    Transcation[] transcationLog;

    function addTranscation(address _from, address _to, uint amount) external {
        Transcation memory _transcation = Transcation(
            _from,
            _to,
            amount,
            transcationLog.length + 1
        );
        transcationLog.push(_transcation);
    }

    function getTranscation(
        uint index
    ) public view returns (address, address, uint, uint) {
        return (
            transcationLog[index].from,
            transcationLog[index].to,
            transcationLog[index].amount,
            transcationLog[index].txId
        );
    }
}
