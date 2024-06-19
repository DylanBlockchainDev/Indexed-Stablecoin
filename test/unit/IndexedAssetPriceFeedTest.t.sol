// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {Test, console} from "lib/forge-std/src/Test.sol";
import {console} from "lib/forge-std/src/console.sol";
import {IndexedAssetPriceFeed} from "../../src/libraries/IndexedAssetPriceFeed.sol";
import {MockIndexedAssetPriceFeed} from "../mocks/MockIndexedAssetPriceFeed.sol";
import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {MockV3Aggregator} from "../mocks/MockV3Aggregator.sol";

contract IndexedAssetPriceFeedTest is Test {
   IndexedAssetPriceFeed public indexedAssetPriceFeed;
   MockIndexedAssetPriceFeed public mockIndexedAssetPriceFeed;
   AggregatorV3Interface[] public priceFeeds;
   MockV3Aggregator[] public mockPriceFeeds;

   uint8 public decimals;
   int256 public version;

    function setUp() public {
        decimals = 8;
        version = 1;

        // Create mock price feeds
        MockV3Aggregator mockPriceFeed1 = new MockV3Aggregator(decimals, version);
        MockV3Aggregator mockPriceFeed2 = new MockV3Aggregator(decimals, version);
        MockV3Aggregator mockPriceFeed3 = new MockV3Aggregator(decimals, version);

        // Set the price for each mock price feed
        mockPriceFeed1.updateRoundData(0, 1000, 0, 0);
        mockPriceFeed2.updateRoundData(0, 2000, 0, 0);
        mockPriceFeed3.updateRoundData(0, 3000, 0, 0);

        // Print out the addresses of the mock price feeds
        console.log("Address of mockPriceFeed1: %s", address(mockPriceFeed1));
        console.log("Address of mockPriceFeed2: %s", address(mockPriceFeed2));
        console.log("Address of mockPriceFeed3: %s", address(mockPriceFeed3));

        // Add the mock price feeds to the price feeds array
        priceFeeds = new AggregatorV3Interface[](3);
        priceFeeds[0] = AggregatorV3Interface(address(mockPriceFeed1));
        priceFeeds[1] = AggregatorV3Interface(address(mockPriceFeed2));
        priceFeeds[2] = AggregatorV3Interface(address(mockPriceFeed3));

        // Initialize the IndexedAssetPriceFeed contract with the price feeds array
        indexedAssetPriceFeed = new IndexedAssetPriceFeed(priceFeeds);
    }

    function testUpdatePrice() public {
        // Call the updatePrice function
        uint256 result = indexedAssetPriceFeed.updatePrice();

        // Check if the result is the average price of the mock feeds
        assertTrue(result == 2000, "The average price is not correct");
    }

    function testGetLatestTimeStamp() public {
        decimals = 8;
        version = 1;

        // Create mock price feeds
        MockV3Aggregator mockPriceFeed1 = new MockV3Aggregator(decimals, version);
        MockV3Aggregator mockPriceFeed2 = new MockV3Aggregator(decimals, version);
        MockV3Aggregator mockPriceFeed3 = new MockV3Aggregator(decimals, version);

        // Set the price for each mock price feed
        mockPriceFeed1.updateRoundData(0, 1000, 0, 0);
        mockPriceFeed2.updateRoundData(0, 2000, 0, 0);
        mockPriceFeed3.updateRoundData(0, 3000, 0, 0);

        // Add the mock price feeds to the price feeds array
        priceFeeds = new AggregatorV3Interface[](3);
        priceFeeds[0] = AggregatorV3Interface(address(mockPriceFeed1));
        priceFeeds[1] = AggregatorV3Interface(address(mockPriceFeed2));
        priceFeeds[2] = AggregatorV3Interface(address(mockPriceFeed3));

        // Initialize the IndexedAssetPriceFeed contract with the price feeds array
        indexedAssetPriceFeed = new IndexedAssetPriceFeed(priceFeeds);

        // Get the latest timestamp
        uint256 latestTimestamp = indexedAssetPriceFeed.getLatestTimeStamp();

        // Print out the latest timestamp
        console.log("Latest timestamp: %s", latestTimestamp);

        // Assert that the latest timestamp is correct
        assertTrue(latestTimestamp == 0, "The latest timestamp is not correct");
    }

    function testSetRoundDataForTesting() public {
        decimals = 8;
        version = 1;

        // Create a mock price feed
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(decimals, version);

        // Set the price for the mock price feed
        mockPriceFeed.updateRoundData(0, 1000, 0, 0);

        // Add the mock price feed to the price feeds array
        priceFeeds = new AggregatorV3Interface[](1);
        priceFeeds[0] = AggregatorV3Interface(address(mockPriceFeed));

        // Initialize the MockIndexedAssetPriceFeed contract with the price feeds array
        mockIndexedAssetPriceFeed = new MockIndexedAssetPriceFeed(priceFeeds);

        // Update the round data of the mock price feed
        mockIndexedAssetPriceFeed.setRoundDataForTesting(address(mockPriceFeed), 1, 2000, 0, 0);

        // Get the round data of the mock price feed
        (,int256 price,,,) = mockPriceFeed.latestRoundData();

        // Print out the price of the mock price feed
        // console.log("Price of mock price feed: %s", price);

        // Assert that the price of the mock price feed is correct
        assertTrue(price == 2000, "The price of the mock price feed is not correct");
    }
}
