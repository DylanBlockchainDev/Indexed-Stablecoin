// SPDX-License-Identifier: MIT
pragma solidity ^0.8.19;

// import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {console} from "lib/forge-std/src/console.sol";
import { IndexedAssetPriceFeed } from './IndexedAssetPriceFeed.sol';
import {AggregatorV3Interface} from "../../lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";


/*
 * @title OracleLib
 * @author Patrick Collins
 * @notice This library is used to check the Chainlink Oracle for stale data.
 * If a price is stale, functions will revert, and render the DSCEngine unusable - this is by design.
 * We want the DSCEngine to freeze if prices become stale.
 *
 * So if the Chainlink network explodes and you have a lot of money locked in the protocol... too bad.
 */
library OracleLib {
    error OracleLib__StalePrice(string message);

    uint256 private constant TIMEOUT = 3 hours;

    function staleCheckLatestRoundData(IndexedAssetPriceFeed indexedAssetPriceFeed)
        public returns (uint256)
    {
        uint256 price = indexedAssetPriceFeed.getLatestPrice();

        // console.log(price);

        uint256 secondsSince = block.timestamp - indexedAssetPriceFeed.getLatestTimeStamp();

        // console.log("seconds Since Latest timestamp: %s", secondsSince);

        if (secondsSince > getTimeout()) revert OracleLib__StalePrice("Stale price detected");

        // console.log(price);

        return price;
    }

    function getTimeout() public pure returns (uint256) {
        return TIMEOUT;
    }


    // AggregatorV3Interface price tests
    function staleCheckLatestRoundDataOnCollateral(AggregatorV3Interface chainlinkFeed)
        public
        view
        returns (uint80, int256, uint256, uint256, uint80)
    {
        (uint80 roundId, int256 answer, uint256 startedAt, uint256 updatedAt, uint80 answeredInRound) =
            chainlinkFeed.latestRoundData();

        if (updatedAt == 0 || answeredInRound < roundId) {
            revert OracleLib__StalePrice("Stale price detected");
        }
        uint256 secondsSince = block.timestamp - updatedAt;
        if (secondsSince > TIMEOUT) revert OracleLib__StalePrice("Stale price detected");

        return (roundId, answer, startedAt, updatedAt, answeredInRound);
    }

    function getTimeoutAggregatorV3Interface(AggregatorV3Interface /* chainlinkFeed */ ) public pure returns (uint256) {
        return TIMEOUT;
    }
}
