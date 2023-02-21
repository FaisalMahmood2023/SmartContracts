//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

contract Drive {
    mapping(address => string[]) public data;
    mapping(address => mapping(address => bool)) public ownership;

    struct Access {
        address user;
        bool access;
    }

    mapping(address => Access[]) public accessList;
    mapping(address => mapping(address => bool)) public previousData;

    function addImage(address user, string memory url) external {
        data[user].push(url);
    }

    function allow(address user) external {
        ownership[msg.sender][user] = true;

        if (previousData[msg.sender][user]) {
            for (uint256 i = 0; i < accessList[msg.sender].length; i++) {
                if (accessList[msg.sender][i].user == user) {
                    accessList[msg.sender][i].access = true;
                }
            }
        } else {
            accessList[msg.sender].push(Access(user, true));
            previousData[msg.sender][user] = true;
        }
    }

    function disallow(address user) public {
        ownership[msg.sender][user] = false;
        for (uint256 i = 0; i < accessList[msg.sender].length; i++) {
            if (accessList[msg.sender][i].user == user) {
                accessList[msg.sender][i].access = false;
            }
        }
    }

    function display(address user) external view returns (string[] memory) {
        require(
            user == msg.sender || ownership[user][msg.sender],
            "You don't have access"
        );
        return data[user];
    }

    function shareAccess() public view returns (Access[] memory) {
        return accessList[msg.sender];
    }
}
