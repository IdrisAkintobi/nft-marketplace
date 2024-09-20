# NFT Marketplace Project

This project is a smart contract NFT marketplace built using Solidity and deployed via Foundry. The contract allows users to mint, list, and buy NFTs.

## Prerequisites

- **Foundry**: A fast, modular, and efficient Ethereum development framework.
- **Solidity**: Used for writing the smart contract.
- **Environment Variables**: Set up the following environment variables in your `.env` file.

## Environment Variables

The script requires the following environment variables to be set:

```bash
DO_NOT_LEAK=                   # Deployer private key
NFT_MARKETPLACE_ADDRESS=0x...  # Address of the deployed NFTMarketplace contract
OWNER_PRIVATE_KEY=0x...        # Owner's private key for minting and listing NFTs
BUYER_PRIVATE_KEY=0x...        # Buyer's private key for purchasing NFTs
```

## Makefile

The provided `Makefile` automates the process of running, deploying, and interacting with the contracts. Here are the targets defined in the `Makefile`:

### Check

This target ensures that the code is formatted correctly and tests are run:

```bash
make check
```

### Deployment to Sepolia (Lisk Network)

To deploy the `NFTMarketplace` contract to the Sepolia network:

```bash
make NFTMarketplace
```

### Interaction with Deployed Contract (Sepolia)

To interact with the deployed contract on the Sepolia network:

```bash
make NFTMarketplace-script-lisk
```

### Deployment to Localhost

To deploy the `NFTMarketplace` contract on a local blockchain (such as `anvil`):

```bash
make NFTMarketplace-local
```

### Interaction with Deployed Contract (Localhost)

To interact with a deployed contract on a local blockchain:

```bash
make NFTMarketplace-script-local
```

> Ensure that your `.env` file is properly configured with the correct keys and contract address before running the scripts.

## Testing

To run the tests for this project:

```bash
make check
```

## License

This project is licensed under the MIT License.
