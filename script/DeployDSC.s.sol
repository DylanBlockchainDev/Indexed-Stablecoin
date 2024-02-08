// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.19;

import {Script} from "lib/forge-std/src/Script.sol";
import {HelperConfig} from "./HelperConfig.s.sol";
import {DecentralizedStableCoin} from "../src/DecentralizedStableCoin.sol";
import {DSCEngine} from "../src/DSCEngine.sol";
import {IndexedAssetPriceFeed} from "../src/libraries/IndexedAssetPriceFeed.sol";
import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";
import { MockV3Aggregator } from '../test/mocks/MockV3Aggregator.sol';


contract DeployDSC is Script {
    address[] public tokenAddresses;
    address[] public priceFeedAddresses;
    MockV3Aggregator[] public mockPriceFeeds;
    address public indexedAssetPriceFeedAddress;

    function run() external returns (DecentralizedStableCoin, DSCEngine, HelperConfig) {
        HelperConfig helperConfig = new HelperConfig(); // This comes with our mocks!

        (address wethUsdPriceFeed, address wbtcUsdPriceFeed, address weth, address wbtc, uint256 deployerKey) =
            helperConfig.activeNetworkConfig();
        tokenAddresses = [weth, wbtc];
        priceFeedAddresses = [wethUsdPriceFeed, wbtcUsdPriceFeed];

        mockPriceFeeds = new MockV3Aggregator[](10);
        for (uint i = 0; i < 10; i++) {
            uint8 _decimals = 8;
            int256 _initialAnswer = 2000 ether;
            mockPriceFeeds[i] = new MockV3Aggregator(_decimals, _initialAnswer);
        }

        AggregatorV3Interface[] memory priceFeeds = new AggregatorV3Interface[](tokenAddresses.length);
        for (uint i =  0; i < tokenAddresses.length; i++) {
            priceFeeds[i] = AggregatorV3Interface(priceFeedAddresses[i]);
        }

        indexedAssetPriceFeedAddress = helperConfig.deployIndexedAssetPriceFeed(priceFeeds);

        vm.startBroadcast(deployerKey);
        DecentralizedStableCoin dsc = new DecentralizedStableCoin();
        DSCEngine dscEngine = new DSCEngine(
            tokenAddresses,
            priceFeedAddresses,
            address(dsc),
            indexedAssetPriceFeedAddress
        );
        dsc.transferOwnership(address(dscEngine));
        vm.stopBroadcast();
        return (dsc, dscEngine, helperConfig);
    }
}
