//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "./Ownerable2.sol";

contract Lottery is Ownerable {
    address payable[] public players;
    address payable public winner;

    // function deposit() public payable {
    //     require(msg.value == 1e18, "You must be deposit 1 Ether for Participant in Lottery System");
    //     players.push(payable(msg.sender));
    // }

    receive() external payable {
        require(
            msg.value == 1e18,
            "You must be deposit 1 Ether for Participant in Lottery System"
        );
        players.push(payable(msg.sender));
    }

    function getBalance() public view onlyOwner returns (uint) {
        return address(this).balance;
    }

    function random() public view returns (uint) {
        return
            uint(
                keccak256(
                    abi.encodePacked(
                        // block.difficulty,
                        block.timestamp,
                        players.length
                    )
                )
            );
    }

    function pickWinner() public onlyOwner {
        require(players.length >= 3, "Players are less than 3");

        uint r = random();
        uint index = r % players.length;
        winner = players[index];
        uint ownerFees = 1e18;
        uint balance = getBalance() - ownerFees;
        winner.transfer(balance);
        payable(owner).transfer(ownerFees);
        players = new address payable[](0);
    }

    function allPlayers() public view returns (address payable[] memory) {
        return players;
    }
}
