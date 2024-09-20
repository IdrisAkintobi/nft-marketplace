# Load environment variables from .env
include .env
export $(shell sed 's/=.*//' .env)

# Formatting and Testing prerequisite
.PHONY: check
check:
	forge fmt
	forge test

# Deployment targets
NFTMarketplace: check
	forge script script/NFTMarketplace.s.sol --rpc-url lisk-sepolia --broadcast --verify

NFTMarketplace-script-lisk:
	forge script script/NFTMarketplaceInteraction.s.sol --rpc-url lisk-sepolia --broadcast

NFTMarketplace-local: check
	forge script script/NFTMarketplace.s.sol --rpc-url localhost --broadcast
	# Ensure the DO_NOT_KEY is updated in the env file.

NFTMarketplace-script-local:
	forge script script/NFTMarketplaceInteraction.s.sol --rpc-url localhost --broadcast
	# Ensure the DO_NOT_KEY is updated in the env file.
