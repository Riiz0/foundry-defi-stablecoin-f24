// SPDX-License-Identifier: MIT

pragma solidity ^0.8.18;

import {AggregatorV3Interface} from
    "lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

/**
 * @title OracleLib
 * @author Shawn Rizo
 * @notice This library is used to check the chainlink oracle for stale data.
 * @notice if a price is stale, the function will revert, and render the DSCEngine unusable - this is by design.
 * we want the DSCEngine to freeze if prices become stale.
 */
library OracleLib {
    error OracleLib__STALEPRICE();

    uint256 private constant TIMEOUT = 3 hours;

    function staleCheckLatestRoundData(AggregatorV3Interface priceFeed)
        public
        view
        returns (uint80, int256, uint256, uint256, uint80)
    {
        (uint80 roundId, int256 answer, uint256 startAt, uint256 updateAt, uint80 answeredInRound) =
            priceFeed.latestRoundData();

        uint256 secondsSince = block.timestamp - updateAt;
        if (secondsSince > TIMEOUT) {
            revert OracleLib__STALEPRICE();
        }
        return (roundId, answer, startAt, updateAt, answeredInRound);
    }
}
