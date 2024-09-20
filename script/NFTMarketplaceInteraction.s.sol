// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "forge-std/Script.sol";
import "../src/NFTMarketplace.sol";

contract NFTMarketplaceInteraction is Script {
    NFTMarketplace public nftMarketplace;
    address public owner;
    address public buyer;

    function setUp() public {
        address contractAddress = vm.envAddress("NFT_MARKETPLACE_ADDRESS");
        nftMarketplace = NFTMarketplace(contractAddress);

        owner = vm.addr(vm.envUint("OWNER_PRIVATE_KEY"));
        buyer = vm.addr(vm.envUint("BUYER_PRIVATE_KEY"));
    }

    function run() public {
        vm.startBroadcast(vm.envUint("OWNER_PRIVATE_KEY"));

        // Mint an NFT by the owner
        console.log("Minting NFT...");
        nftMarketplace.mintNFT(owner);
        uint256 tokenId = 1;
        console.log("NFT minted with tokenId:", tokenId);

        // List the NFT for sale
        console.log("Listing NFT for sale...");
        nftMarketplace.listNFT(tokenId, 1 gwei);
        console.log("NFT listed with price (in wei):", "1 gwei");

        vm.stopBroadcast();

        // Broadcast as the buyer
        vm.deal(buyer, 1 gwei); // Give buyer 1 gwei for the purchase
        vm.startBroadcast(vm.envUint("BUYER_PRIVATE_KEY"));

        // Buyer purchases the NFT
        console.log("Buyer attempting to buy the NFT...");
        nftMarketplace.buyNFT{ value: 1 gwei }(tokenId);
        console.log("NFT bought by buyer:", buyer);

        // Check new owner of the NFT
        address newOwner = nftMarketplace.ownerOf(tokenId);
        console.log("New owner of tokenId", tokenId, "is:", newOwner);

        vm.stopBroadcast();
    }
}
