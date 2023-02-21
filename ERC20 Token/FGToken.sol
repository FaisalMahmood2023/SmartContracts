//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FGToken is ERC20Capped, Ownable {
    address payable public manager;

    // uint256 public blockReward;

    constructor(
        uint256 cap
    )
        // uint256 reward
        ERC20("FGToken", "FG")
        ERC20Capped(cap * (10 ** decimals()))
    {
        manager = payable(msg.sender);
        _mint(manager, 700 * (10 ** decimals()));
        // blockReward = reward * (10 ** decimals());
    }

    function minting(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }

    function burn(uint256 amount) public virtual onlyOwner {
        _burn(_msgSender(), amount);
    }

    function destroy() public onlyOwner {
        selfdestruct(manager);
    }

    // function mintMinerReward() internal {
    //     _mint(block.coinbase, blockReward);
    // }

    // function _beforeTokenTransfer(
    //     address from,
    //     address to,
    //     uint256 value
    // ) internal virtual override {
    //     if (
    //         from != address(0) &&
    //         to != block.coinbase &&
    //         block.coinbase != address(0)
    //     ) {
    //         mintMinerReward();
    //     }
    //     super._beforeTokenTransfer(from, to, value);
    // }

    // function setBlockReward(uint256 reward) public onlyOwner {
    //     blockReward = reward * (10 ** decimals());
    // }

    // function _mint(address account, uint256 amount) internal virtual override {
    //     require(
    //         ERC20.totalSupply() + amount <= cap(),
    //         "ERC20Capped: cap exceeded"
    //     );
    //     super._mint(account, amount);
    // }

    // function burnFrom(address account, uint256 amount) public virtual {
    //     _spendAllowance(account, _msgSender(), amount);
    //     _burn(account, amount);
    // }
}
