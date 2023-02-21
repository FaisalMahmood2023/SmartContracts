//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "./ERC20STD.sol";
import "./Ownerable.sol";

contract ERC20Token is ERC20STD, Ownerable {
    string _name;
    string _symbol;
    uint8 _decimals;
    uint256 _totalSupply;

    address public _minter;
    mapping(address => uint256) public totalBalances;
    mapping(address => mapping(address => uint256)) public allowed;

    constructor(address minter_) {
        _name = "Tenup";
        _symbol = "TUP";
        _decimals = 0;
        _totalSupply = 10000;
        _minter = minter_;
        totalBalances[_minter] = _totalSupply;
    }

    function name() public view override returns (string memory) {
        return _name;
    }

    function symbol() public view override returns (string memory) {
        return _symbol;
    }

    function decimals() public view override returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view override returns (uint256) {
        return _totalSupply;
    }

    function balanceOf(
        address _owner
    ) public view override returns (uint256 balance) {
        return totalBalances[_owner];
    }

    function transfer(
        address _to,
        uint256 _value
    ) public override returns (bool success) {
        require(totalBalances[msg.sender] >= _value, "Insufficient Tokens");

        totalBalances[msg.sender] -= _value;
        totalBalances[_to] += _value;

        emit Transfer(msg.sender, _to, _value);

        return true;
    }

    function transferFrom(
        address _from,
        address _to,
        uint256 _value
    ) public override returns (bool success) {
        require(totalBalances[_from] >= _value);
        require(allowed[_from][msg.sender] >= _value, "Insufficient Balance");

        totalBalances[_from] -= _value;
        totalBalances[_to] += _value;
        allowed[_from][msg.sender] -= _value;

        emit Transfer(_from, _to, _value);

        return true;
    }

    function increseAllowance(
        address _spender,
        uint256 _value
    ) public override returns (bool success) {
        allowed[msg.sender][_spender] += _value;
        return true;
    }

    function decreaseAllowance(
        address _spender,
        uint256 _value
    ) public override returns (bool success) {
        allowed[msg.sender][_spender] -= _value;
        return true;
    }

    function approve(
        address _spender,
        uint256 _value
    ) public override returns (bool success) {
        require(_spender != address(0));
        require(totalBalances[msg.sender] >= _value, "Insufficient Tokens");

        allowed[msg.sender][_spender] = _value;

        emit Approval(msg.sender, _spender, _value);

        return true;
    }

    function allowance(
        address _owner,
        address _spender
    ) public view override returns (uint256 remaining) {
        return allowed[_owner][_spender];
    }

    function mintToken(uint _value) public returns (bool success) {
        require(msg.sender == owner, "only admin has this access");

        _totalSupply += _value;
        totalBalances[owner] += _value;

        return true;
    }

    function burnToken(uint _value) public returns (bool success) {
        require(msg.sender == owner, "only admin has this access");

        _totalSupply -= _value;
        totalBalances[owner] -= _value;

        return true;
    }
}
