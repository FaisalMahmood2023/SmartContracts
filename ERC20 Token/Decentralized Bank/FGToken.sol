//SPDX-License-Identifier: MIT
pragma solidity >=0.5.0 <0.9.0;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Capped.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract FGToken is ERC20Capped, Ownable {
    constructor(
        uint256 cap
    ) ERC20("FGToken", "FG") ERC20Capped(cap * (10 ** decimals())) {
        _mint(_msgSender(), 700 * (10 ** decimals()));
    }

    function minting(address account, uint256 amount) external onlyOwner {
        _mint(account, amount);
    }

    function burn(uint256 amount) public virtual onlyOwner {
        _burn(_msgSender(), amount);
    }

    function burnFrom(address account, uint256 amount) public virtual {
        _spendAllowance(account, _msgSender(), amount);
        _burn(account, amount);
    }

    function destroy() public onlyOwner {
        selfdestruct(payable(_msgSender()));
    }
}
