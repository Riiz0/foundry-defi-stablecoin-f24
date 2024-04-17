// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

/*
 * @title DecentralizedStableCoin
 * @author Shawn Rizo
 * Collateral: Exogenous (BTC & ETH)
 * Minting: Algorithmic
 * Relative StabilityL Pegged to USD
 * 
 * This is the contract meant to be governed by DSCEgine. 
 This contract is just the ERC20 implementation of our stablecoin system.
 */

import {ERC20, ERC20Burnable} from "@openzeppelin/contracts/token/ERC20/extensions/ERC20Burnable.sol";
import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";

contract DecentralizedStableCoin is ERC20Burnable, Ownable {
    error DecentralizedStableCoin__MustBeMoreThanZero();
    error DecentralizedStableCoin__BurnAmountExceedsBalance();
    error DecentralizedStableCoin__CantMintToZeroAddress();

    constructor(
        address initialOwner
    ) Ownable(initialOwner) ERC20("DecentralizedStableCoin", "DSC") {}

    function burn(uint256 _amount) public override onlyOwner {
        uint256 balance = balanceOf(msg.sender);
        if (_amount <= 0) {
            revert DecentralizedStableCoin__MustBeMoreThanZero();
        }
        if (balance < _amount) {
            revert DecentralizedStableCoin__BurnAmountExceedsBalance();
        }
        super.burn(_amount);
    }

    function mint(
        address _to,
        uint256 _amount
    ) external onlyOwner returns (bool) {
        if (_to == address(0)) {
            revert DecentralizedStableCoin__CantMintToZeroAddress();
        }
        if (_amount <= 0) {
            revert DecentralizedStableCoin__MustBeMoreThanZero();
        }
        _mint(_to, _amount);
        return true;
    }
}
