// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

abstract contract ERC20Capped is ERC20 {
    uint256 private _cap;

    constructor(uint256 __cap) public {
        require(__cap > 0, "ERC20Capped: cap is 0");
        _cap = __cap;
    }

    function cap() public view virtual returns (uint256) {
        return _cap;
    }

    function _mint(address account, uint256 amount) internal virtual override {
        if (ERC20.totalSupply() + amount > cap()) {
            uint256 correctedAmount = cap() - ERC20.totalSupply();
            super._mint(account, correctedAmount);
        } else {
            super._mint(account, amount);
        }
    }
}
