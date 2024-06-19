// SPDX-License-Identifier: MIT

pragma solidity 0.8.20;

import {AggregatorV3Interface} from "../../lib/chainlink-brownie-contracts/contracts/src/v0.8/interfaces/AggregatorV3Interface.sol";

// This contract aggregates the multiple prices from multiple chainlink price feeds (all must be USD pairs) and adds up all the prices and then divides the total by the number of price feeds returning an indexed average value which will be used for the DSC token to be pegged to. 
// Apologies for the poor documentation, it's still a skill being practiced.

contract IndexedAssetPriceFeed {
    // error PriceTooHigh(uint256 givenPrice);

    AggregatorV3Interface[] public priceFeeds;
    uint256 public lastKnownPrice;

    mapping(address => uint256) public prices;

  // can pass in the priceFeed Addresses in on deployment 
  // like this'IndexedAssetPriceFeed indexedAssetPriceFeed = new IndexedAssetPriceFeed([address1, address2, address3]);' 

    constructor(AggregatorV3Interface[] memory _priceFeeds) {
        priceFeeds = _priceFeeds;
    }

    function getLatestPrice() external returns (uint256) {
      return updatePrice();
    }

    function updatePrice() public returns(uint256) {
        uint256 total = 0;
        uint256 count = 0;
        for (uint256 i = 0; i < priceFeeds.length; i++) {
            try priceFeeds[i].latestRoundData() returns (uint80, int256 price, uint256, uint256, uint80) {
                prices[address(priceFeeds[i])] = uint256(price);
                total += uint256(price);
                count++;
            } catch {
                revert("Call to latestRoundData failed");
            }
        }
        lastKnownPrice = total / count;
        return lastKnownPrice;
    }

    function getLatestTimeStamp() external view returns (uint256) {
        uint256 latestTimeStamp = 0;
        for (uint256 i = 0; i < priceFeeds.length; i++) {
            (, , , uint256 updatedAt, ) = priceFeeds[i].latestRoundData();
            if (updatedAt > latestTimeStamp) {
                latestTimeStamp = updatedAt;
            }
        }
        return latestTimeStamp;
    }

    function getPriceFeeds() external view returns (AggregatorV3Interface[] memory) {
        return priceFeeds;
    }

}
