// SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

abstract contract ERC20STD {
    function name() public view virtual returns (string memory);

    function symbol() public view virtual returns (string memory);

    function decimals() public view virtual returns (uint8);

    function totalSupply() public view virtual returns (uint256);

    function balanceOf(
        address _owner
    ) public view virtual returns (uint256 balance);

    function transfer(
        address _to,
        uint256 _value
    ) public virtual returns (bool success);

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public virtual returns (bool success);

    function approve(
        address _spender,
        uint256 _value
    ) public virtual returns (bool success);

    function allowance(
        address _owner,
        address _spender
    ) public view virtual returns (uint256 remaining);

    function increseAllowance(
        address _spender,
        uint256 _value
    ) public virtual returns (bool success);

    function decreaseAllowance(
        address _spender,
        uint256 _value
    ) public virtual returns (bool success);

    event Transfer(address indexed _from, address indexed _to, uint256 _value);
    event Approval(
        address indexed _owner,
        address indexed _spender,
        uint256 _value
    );
}
