// SPDX-License-Identifier: MIT

pragma solidity ^0.8.19;

import {MockV3Aggregator} from "../mocks/MockV3Aggregator.sol";
import {AggregatorV3Interface} from "lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import {Test, console} from "lib/forge-std/src/Test.sol";
import {StdCheats} from "lib/forge-std/src/StdCheats.sol";
import {console} from "lib/forge-std/src/console.sol";
import {OracleLib, IndexedAssetPriceFeed} from "../../src/libraries/OracleLib.sol";

contract OracleLibTest is StdCheats, Test {
    using OracleLib for IndexedAssetPriceFeed;

    IndexedAssetPriceFeed public aggregator;
    MockV3Aggregator public mockAggregator;
    uint8 public constant DECIMALS = 8;
    int256 public constant INITAL_PRICE = 2000 ether;

    address public _mockPriceFeedAddress;

    function setUp() public {
        // // Create instances of MockV3Aggregator
        MockV3Aggregator[] memory mockPriceFeeds = new MockV3Aggregator[](10);
        for (uint i = 0; i < 10; i++) {
            uint8 _decimals = 8;
            int256 _initialAnswer = 2000 ether;
            mockPriceFeeds[i] = new MockV3Aggregator(_decimals, _initialAnswer);
        }

        // Create an array of AggregatorV3Interface
        AggregatorV3Interface[] memory priceFeeds = new AggregatorV3Interface[](10);
        for (uint i = 0; i < 10; i++) {
            priceFeeds[i] = AggregatorV3Interface(address(mockPriceFeeds[i]));
        }

        // Pass the instances to the IndexedAssetPriceFeed contract
        aggregator = new IndexedAssetPriceFeed(priceFeeds);

        mockAggregator = new MockV3Aggregator(DECIMALS, INITAL_PRICE);

        // Set _mockPriceFeedAddress to the address of the first mock price feed
        _mockPriceFeedAddress = address(mockPriceFeeds[5]);
    }


    function testGetTimeout() public {
        uint256 expectedTimeout = 3 hours;
        assertEq(OracleLib.getTimeout(), expectedTimeout);
    }

    // Foundry Bug - I have to make staleCheckLatestRoundData public
    function testPriceRevertsOnStaleCheck() public {
        vm.warp(block.timestamp + 4 hours + 1 seconds);
        vm.roll(block.number + 1);

        try IndexedAssetPriceFeed(address(aggregator)).staleCheckLatestRoundData() {
            fail("Expected revert not received");
        } catch (bytes memory /*lowLevelData*/) {
            // This will only be executed if the call reverts, otherwise it will fail
            // You can add further checks here to validate the revert reason
        }

    }

    function testPriceRevertsOnBadAnsweredInRound() public {
        uint80 _roundId = 0;
        int256 _answer = 0;
        uint256 _timestamp = block.timestamp + 2; // 2 - infinity
        uint256 _startedAt = 0;
        aggregator.setRoundDataForTesting(_mockPriceFeedAddress, _roundId, _answer, _timestamp, _startedAt);

        try IndexedAssetPriceFeed(address(aggregator)).staleCheckLatestRoundData() {
            fail("Expected revert not received");
        } catch (bytes memory /*lowLevelData*/) {
            // This will only be executed if the call reverts, otherwise it will fail
            // You can add further checks here to validate the revert reason
        }
    }

    // AggregatorV3Interface Tests

    function testGetTimeoutAggregatorV3Interface() public { // check aggregator !!!!!!!!!!!!!!!!!!!!!!!!!!!
        uint256 expectedTimeout = 3 hours;
        assertEq(OracleLib.getTimeoutAggregatorV3Interface(AggregatorV3Interface(address(aggregator))), expectedTimeout);
    }

    function testPriceRevertsOnStaleCheckAggregatorV3Interface() public { // check aggregator !!!!!!!!!!!!!!!!!!!!!!!!!!!
        vm.warp(block.timestamp + 4 hours + 1 seconds);
        vm.roll(block.number + 1);

        vm.expectRevert(OracleLib.OracleLib__StalePrice.selector);
        // OracleLib.staleCheckLatestRoundDataOnCollateral(AggregatorV3Interface(address(aggregator)));

        try OracleLib.staleCheckLatestRoundDataOnCollateral(AggregatorV3Interface(address(aggregator))) {
            fail("Expected revert not received");
        } catch (bytes memory /*lowLevelData*/) {
            // This will only be executed if the call reverts, otherwise it will fail
            // You can add further checks here to validate the revert reason
        }
    }

    function testPriceRevertsOnBadAnsweredInRoundAggregatorV3Interface() public { // check aggregator !!!!!!!!!!!!!!!!!!!!!!!!!!!
        uint80 _roundId = 0;
        int256 _answer = 0;
        uint256 _timestamp = 0;
        uint256 _startedAt = 0;
        mockAggregator.updateRoundData(_roundId, _answer, _timestamp, _startedAt);

        vm.expectRevert(OracleLib.OracleLib__StalePrice.selector);
        // OracleLib.staleCheckLatestRoundDataOnCollateral(AggregatorV3Interface(address(aggregator)));

        try OracleLib.staleCheckLatestRoundDataOnCollateral(AggregatorV3Interface(address(aggregator))) {
            fail("Expected revert not received");
        } catch (bytes memory /*lowLevelData*/) {
            // This will only be executed if the call reverts, otherwise it will fail
            // You can add further checks here to validate the revert reason
        }
    }
}
