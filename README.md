# Indexed-Stablecoin Project README

**Author:** Dylan Katsch

**Credit:** This project is based on Patrick Collins's course, ["Learn Solidity, Blockchain Development, & Smart Contracts | Powered By AI - Full Course" "Lesson 12: Foundry DeFi | Stablecoin (The PINNACLE PROJECT!! GET HERE!)"](https://github.com/Cyfrin/foundry-defi-stablecoin-f23).
Which you could also see on "Cyfrin Updrafte" at 'updraft.cyfrin.io'.

## Introduction

The Decentralized Stable Coin Engine (DSCEngine) is a blockchain-based solution designed to create a decentralized stablecoin (DSC). A stablecoin is pegged to a stable asset or reference price, typically a fiat currency like USD, ensuring stability in its value. This README provides an overview of the DSCEngine project, explaining its purpose, functionality, and key components.

## Project Overview

The DSCEngine project aims to develop a decentralized stablecoin that leverages Chainlink's Price Feeds to securely integrate real-world market data, ensuring the stability of the DSC token's value.

## How It Works

1. **Integration with Chainlink Price Feeds:**

   - The DSCEngine integrates with Chainlink Price Feeds to get the latest market data for various asset pairs. This leverages the robust and reliable data provided by Chainlink's decentralized oracle network (DON).

2. **Indexed Asset Price Feed:**

   - The engine employs an IndexedAssetPriceFeed contract to calculate an indexed average price from multiple price feeds (they have to be USD pairs). This indexed price represents the overall market stability and is used to peg the DSC token's value.

3. **Collateral Deposit and Minting:**

   - Users can deposit collateral in the form of ERC20 tokens. The engine then mints DSC tokens proportionally to the value of the collateral, based on the indexed average price.

4. **Redemption and Burning:**

   - Users can redeem their collateral by burning DSC tokens. The engine checks the health factor to ensure that the redemption does not compromise the user's position or the overall stability of the system.

5. **Liquidation Mechanism:**

   - The engine includes a liquidation mechanism that allows for the liquidation of undercollateralized positions to maintain the health factor and protect the system from potential losses.

6. **Smart Contract Interactions:**

   - The DSCEngine interacts with a DecentralizedStableCoin contract to mint and burn DSC tokens. The smart contracts are designed to be secure and resistant to common attacks, including reentrancy attacks.

7. **Multiple Layers of Security:**
   - The engine incorporates multiple layers of security, including data source aggregation, node operator aggregation, and oracle network aggregation. These layers work together to maintain high data quality and tamper resistance.

## Key Components

- **DSCEngine:**

  - The core smart contract that manages the minting, redemption, and burning of DSC tokens.

- **DecentralizedStableCoin:**

  - The token contract that implements the DSC token and its associated operations.

- **IndexedAssetPriceFeed:**

  - The contract that computes an indexed average price from multiple price feeds to serve as the reference for pegging the DSC token.

- **Chainlink Price Feeds:**
  - External services providing reliable and secure price data for various asset pairs.

## Development and Testing

The DSCEngine project includes comprehensive tests to ensure the correctness and security of the smart contracts. The Foundry forge framework was used to write, test, compile, and deploy the smart contracts. The tests cover various scenarios, including successful minting, insufficient collateral, and health factor breaches.

## Conclusion

The DSCEngine project demonstrates the power of blockchain technology in creating a stable and secure decentralized stablecoin. By leveraging Chainlink's Price Feeds and implementing robust smart contract mechanisms, the engine provides a reliable and transparent way to stabilize digital assets against real-world market conditions.

**Disclaimer:**
I humbly acknowledge that this project is the creation of a learning and aspiring junior blockchain, solidity, web3 developer. I have invested my best efforts, but I cannot guarantee with absolute certainty that everything is error-free and completely secure, despite thorough testing. Therefore, if anyone chooses to utilize this project, it is essential to be well-informed about the actions taken. Moreover, I welcome any constructive feedback, suggestions, or insights from others who may wish to make improvements or highlight potential issues. Your contribution is not only welcome but deeply appreciated.
