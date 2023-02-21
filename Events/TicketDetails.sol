//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "./Event.sol";
import "./TranscationDetails.sol";

interface EventInterface {
    function addTranscation(address _to, uint _amount, uint _eventId) external;
}

contract BuyTickets is EventOrganization {
    EventInterface eventInstance =
        EventInterface(0x8862090A79412D034d9Fb8C9DBFd3194C8D2a2EE);

    mapping(address => mapping(uint => uint)) public tickets;

    function buyTicket(uint _eventId, uint _qty) external payable {
        require(
            events[_eventId].date > block.timestamp,
            "Event has already occured"
        );
        require(events[_eventId].date != 0, "Event does not exit");
        Event storage _buyEventTicket = events[_eventId];
        require(
            msg.value == (_buyEventTicket.price * _qty),
            "Ether is not enough"
        );
        require(_buyEventTicket.ticketRemain >= _qty, "Tickets not Available");
        _buyEventTicket.ticketRemain -= _qty;
        tickets[msg.sender][_eventId] += _qty;
        eventInstance.addTranscation(msg.sender, _qty, _eventId);
    }

    function transferTicket(uint _eventId, uint _qty, address _to) external {
        require(
            events[_eventId].date > block.timestamp,
            "Event has already occured"
        );
        require(events[_eventId].date != 0, "Event does not exit");
        require(
            tickets[msg.sender][_eventId] >= _qty,
            "You donot have enough ticket"
        );
        tickets[msg.sender][_eventId] -= _qty;
        tickets[_to][_eventId] += _qty;
        eventInstance.addTranscation(_to, _qty, _eventId);
    }
}
