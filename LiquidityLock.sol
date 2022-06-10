// SPDX-License-Identifier: AGPL-3.0-only

pragma solidity 0.6.12;

import "@openzeppelin/contracts/token/ERC20/SafeERC20.sol";

/**
 * @dev A token holder contract that will allow a beneficiary to extract the
 * tokens after a given release block number.
 */
contract LiquidityLock {
    using SafeERC20 for IERC20;

    // beneficiary of tokens after they are released
    address private _beneficiary;

    // number when token release is enabled
    uint256 private _releaseBlock;

    constructor(address beneficiary_, uint256 releaseBlock_) public {
        // solhint-disable-next-line not-rely-on-time
        require(
            releaseBlock_ > block.number,
            "LiquidityLock: release time is before current block"
        );
        _beneficiary = beneficiary_;
        _releaseBlock = releaseBlock_;
    }

    /**
     * @return the beneficiary of the tokens.
     */
    function beneficiary() public view virtual returns (address) {
        return _beneficiary;
    }

    /**
     * @return the block number when the tokens are released.
     */
    function releaseBlock() public view virtual returns (uint256) {
        return _releaseBlock;
    }

    /**
     * @notice Transfers tokens held by timelock to beneficiary.
     */
    function release(address _token) public virtual {
        // solhint-disable-next-line not-rely-on-time
        require(
            block.number >= releaseBlock(),
            "LiquidityLock: current time is before release block"
        );
        IERC20 token = IERC20(_token);
        uint256 amount = token.balanceOf(address(this));
        require(amount > 0, "LiquidityLock: no tokens to release");

        token.safeTransfer(beneficiary(), amount);
    }
}
