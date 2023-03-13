//SPDX-License-Identifier: MIT
pragma solidity >= 0.5.0 < 0.9.0;

contract AddressChecker{
    
    //function to check if a given address is a contract or not.
    function isContract(address addressContract) public view returns(bool){
        uint256 size;
        assembly {size := extcodesize(addressContract)}
        return size > 0;
    }
}