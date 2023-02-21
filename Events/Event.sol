//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract EventOrganization {
    struct Event {
        address organiser;
        string name;
        uint date;
        uint price;
        uint ticketCount;
        uint ticketRemain;
    }

    mapping(uint => Event) public events;
    uint public eventId;

    function createEvent(
        string memory _name,
        uint _date,
        uint _price,
        uint _ticketCount
    ) external {
        require(
            (block.timestamp + _date) > block.timestamp,
            "You can organize event for future date"
        );
        require(
            _ticketCount > 0,
            "You can organize event only if you create more than 0 tickets"
        );
        Event storage newEvent = events[eventId];
        eventId++;
        newEvent.organiser = msg.sender;
        newEvent.name = _name;
        newEvent.date = block.timestamp + _date;
        newEvent.price = _price;
        newEvent.ticketCount = _ticketCount;
        newEvent.ticketRemain = _ticketCount;
        // OR
        // events[eventId] = Event(msg.sender, _name, (block.timestamp + _date), _price, _ticketCount, _ticketCount);
    }
}
