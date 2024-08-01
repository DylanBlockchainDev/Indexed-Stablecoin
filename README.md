# Indexed-Stablecoin Project README

**Author:** Dylan Katsch

**Credit:** This project is based on Patrick Collins's course, ["Learn Solidity, Blockchain Development, & Smart Contracts | Powered By AI - Full Course" "Lesson 12: Foundry DeFi | Stablecoin (The PINNACLE PROJECT!! GET HERE!)"](https://github.com/Cyfrin/foundry-defi-stablecoin-f23).
Which you could also see on "Cyfrin Updrafte" at 'updraft.cyfrin.io'.

## Introduction

Welcome to the Indexed Stablecoin Project, an innovative blockchain-based initiative aimed at redefining stability within the cryptocurrency ecosystem. Unlike traditional stablecoins that derive their value from being pegged to a single asset such as fiat currency, commodities, or cryptocurrencies, our Decentralized Stable Coin Engine (DSCEngine) introduces a novel approach to achieving stability.

At the heart of DSCEngine lies the Indexed Stablecoin (DSC), a unique digital asset designed to maintain a stable value over time. What sets DSC apart is its pegging mechanism, which isn't tied to a single reference price but instead to an indexed average value derived from multiple assets. This innovative approach mirrors the strategy of an index fund in traditional finance, offering a diversified and resilient form of stability that mitigates the risks associated with relying on a single underlying asset.

The DSCEngine leverages Chainlink price feeds to aggregate real-time market data across various assets, calculating an indexed average price that serves as the reference point for the DSC's value. This method ensures that fluctuations in the value of individual assets have a minimal impact on the overall stability of the DSC, thereby safeguarding holders against market volatility.

By combining principles of exogenous collateralization, indexed value pegging, and algorithmic stability, the DSCEngine presents a groundbreaking solution in the stablecoin space. It aims to offer a reliable, transparent, and decentralized financial instrument that empowers users with a stable form of cryptocurrency, suitable for transactions, savings, and as a hedge against market volatility.

This README aims to provide a comprehensive overview of the DSCEngine project, detailing its purpose, functionality, underlying technology, and key components. Whether you're a developer looking to contribute, an investor interested in the potential of decentralized finance, or simply curious about the future of stablecoins, we invite you to explore the Indexed Stablecoin Project and join us in shaping the next evolution of digital currencies.

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

## Getting Started

### Requirements

- **[git](https://git-scm.com/book/en/v2/Getting-Started-Installing-Git)**

  - You'll know you did it right if you can run `git --version` and you see a response like `git version x.x.x`

- **[foundry](https://getfoundry.sh/)**

  - You'll know you did it right if you can run `forge --version` and you see a response like `forge 0.2.0 (816e00b 2023-03-16T00:05:26.396218Z)`

### Quickstart

```
git clone https://github.com/DylanBlockchainDev/Indexed-Stablecoin
cd Indexed-Stablecoin
forge build
```

## Testing

We used 2 types of testing in the project

1. **Unit testing**
2. **Fuzz testing**

Use these commands to run tests and see coverage

```
forge test
```

```
forge coverage
```

## Conclusion

The DSCEngine project demonstrates the power of blockchain technology in creating a stable and secure decentralized stablecoin. By leveraging Chainlink's Price Feeds and implementing robust smart contract mechanisms, the engine provides a reliable and transparent way to stabilize digital assets against real-world market conditions.

**Disclaimer:**
I humbly acknowledge that this project is the creation of a learning and aspiring junior blockchain, solidity, web3 developer. I have invested my best efforts, but I cannot guarantee with absolute certainty that everything is error-free and completely secure, despite thorough testing. Therefore, if anyone chooses to utilize this project, it is essential to be well-informed about the actions taken. Moreover, I welcome any constructive feedback, suggestions, or insights from others who may wish to make improvements or highlight potential issues. Your contribution is not only welcome but deeply appreciated.
