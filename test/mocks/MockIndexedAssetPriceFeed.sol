// SPDX--License-Identifier: MIT

pragma solidity 0.8.20;

import {IndexedAssetPriceFeed, AggregatorV3Interface} from "../../src/libraries/IndexedAssetPriceFeed.sol";
import {MockV3Aggregator} from "../../test/mocks/MockV3Aggregator.sol";

contract MockIndexedAssetPriceFeed is IndexedAssetPriceFeed {

    MockV3Aggregator[] public mockPriceFeeds;

    constructor(AggregatorV3Interface[] memory _priceFeeds) IndexedAssetPriceFeed(_priceFeeds) {}

    function setRoundDataForTesting(address _mockPriceFeedAddress, uint80 _roundId, int256 _answer, uint256 _timestamp, uint256 _startedAt) external {
        MockV3Aggregator mockPriceFeed = MockV3Aggregator(_mockPriceFeedAddress);
        mockPriceFeed.updateRoundData(_roundId, _answer, _timestamp, _startedAt);
    }

}