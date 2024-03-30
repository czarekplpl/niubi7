// SPDX-License-Identifier: MIT
pragma solidity 0.8.25;

import "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/security/Pausable.sol";
import "@openzeppelin/contracts/security/ReentrancyGuard.sol";

/**
 * @title SimplePrivateToken
 * @dev A very simple ERC-20 token with basic administrative controls and safety features.
 * Implements burn functionality, pausability for emergency stopping, and reentrancy guards.
 */
contract SimplePrivateToken is ERC20Burnable, Ownable, Pausable, ReentrancyGuard {
    uint256 public constant INITIAL_SUPPLY = 1e6 * 1e18;

    constructor() ERC20("SimplePrivateToken", "SPT") {
        _mint(msg.sender, INITIAL_SUPPLY);
    }

    /**
     * @notice Mint new tokens to the specified account.
     * @param to The account address that will receive the newly minted tokens.
     * @param amount The amount of tokens to mint.
     */
    function mint(address to, uint256 amount) public onlyOwner whenNotPaused nonReentrant {
        _mint(to, amount);
    }

    /**
     * @notice Allows the owner to pause all token transfers in case of emergency.
     */
    function pause() public onlyOwner {
        _pause();
    }

    /**
     * @notice Allows the owner to unpause the contract and resume token transfers.
     */
    function unpause() public onlyOwner {
        _unpause();
    }

    /**
     * @dev Override of ERC20's `_beforeTokenTransfer` to enforce pausing.
     */
    function _beforeTokenTransfer(address from, address to, uint256 amount)
        internal
        override(ERC20)
        whenNotPaused
    {
        super._beforeTokenTransfer(from, to, amount);
    }
}
