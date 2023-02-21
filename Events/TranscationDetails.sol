//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract TranscationDetails {
    struct Transcation {
        address to;
        uint qty;
        uint eventId;
    }

    Transcation[] public transcationLog;

    function addTranscation(address _to, uint _qty, uint _eventId) external {
        Transcation memory _transcation = Transcation(_to, _qty, _eventId);
        transcationLog.push(_transcation);
    }
}
