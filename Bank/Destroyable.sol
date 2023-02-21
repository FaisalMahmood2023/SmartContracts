// SPDX-License-Identifier: MIT
pragma solidity 0.7.5;

import "./Ownerable.sol";

contract Destroyable is Ownerable {
    function destroy() public onlyOwner {
        address payable _receiver = msg.sender;
        selfdestruct(_receiver);
    }
}
