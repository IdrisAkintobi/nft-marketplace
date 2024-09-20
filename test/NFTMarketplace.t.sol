// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import { Test, console } from "forge-std/Test.sol";
import { NFTMarketplace } from "../src/NFTMarketplace.sol";

contract NFTMarketplaceTest is Test {
    NFTMarketplace public nftMarketplace;
    address public owner = address(0x123);
    address public buyer = address(0x456);

    function setUp() public {
        // Start test as the contract owner
        vm.startPrank(owner);
        nftMarketplace = new NFTMarketplace();
        vm.stopPrank();
    }

    // Test minting an NFT as owner
    function testMintNFTAsOwner() public {
        vm.startPrank(owner);
        nftMarketplace.mintNFT(owner);
        uint256 tokenId = 1;
        assertEq(nftMarketplace.ownerOf(tokenId), owner);
        vm.stopPrank();
    }

    // Test minting an NFT as non-owner should revert
    function testMintNFTAsNonOwner() public {
        vm.startPrank(buyer);
        vm.expectRevert(NFTMarketplace.OnlyOwnerCanPerformThisAction.selector);
        nftMarketplace.mintNFT(buyer);
        vm.stopPrank();
    }

    // Test listing an NFT for sale by the owner
    function testListNFT() public {
        vm.startPrank(owner);
        nftMarketplace.mintNFT(owner);
        uint256 tokenId = 1;
        nftMarketplace.listNFT(tokenId, 1 ether);

        (uint256 price, address seller, bool isListed) = nftMarketplace.nftSales(tokenId);
        assertEq(price, 1 ether);
        assertEq(seller, owner);
        assertTrue(isListed);

        vm.stopPrank();
    }

    // Test listing an NFT by non-owner should revert
    function testListNFTByNonOwner() public {
        vm.startPrank(owner);
        nftMarketplace.mintNFT(owner);
        uint256 tokenId = 1;
        vm.stopPrank();

        vm.startPrank(buyer);
        vm.expectRevert(NFTMarketplace.NotTokenOwner.selector);
        nftMarketplace.listNFT(tokenId, 1 ether);
        vm.stopPrank();
    }

    // Test buying an NFT successfully
    function testBuyNFT() public {
        vm.startPrank(owner);
        nftMarketplace.mintNFT(owner);
        uint256 tokenId = 1;
        nftMarketplace.listNFT(tokenId, 1 ether);
        vm.stopPrank();

        vm.deal(buyer, 1 ether); // Give buyer 1 ether
        vm.startPrank(buyer);
        nftMarketplace.buyNFT{ value: 1 ether }(tokenId);
        assertEq(nftMarketplace.ownerOf(tokenId), buyer);
        vm.stopPrank();
    }

    // Test buying an NFT with insufficient funds should revert
    function testBuyNFTInsufficientFunds() public {
        vm.startPrank(owner);
        nftMarketplace.mintNFT(owner);
        uint256 tokenId = 1;
        nftMarketplace.listNFT(tokenId, 1 ether);
        vm.stopPrank();

        vm.deal(buyer, 0.5 ether); // Give buyer only 0.5 ether
        vm.startPrank(buyer);
        vm.expectRevert(NFTMarketplace.InsufficientFunds.selector);
        nftMarketplace.buyNFT{ value: 0.5 ether }(tokenId);
        vm.stopPrank();
    }

    // Test transferring an NFT successfully
    function testTransferNFT() public {
        vm.startPrank(owner);
        nftMarketplace.mintNFT(owner);
        uint256 tokenId = 1;
        nftMarketplace.transferNFT(buyer, tokenId);
        assertEq(nftMarketplace.ownerOf(tokenId), buyer);
        vm.stopPrank();
    }

    // Test transferring a listed NFT should revert
    function testTransferListedNFT() public {
        vm.startPrank(owner);
        nftMarketplace.mintNFT(owner);
        uint256 tokenId = 1;
        nftMarketplace.listNFT(tokenId, 1 ether);
        vm.expectRevert(NFTMarketplace.CannotTransferListedNFT.selector);
        nftMarketplace.transferNFT(buyer, tokenId);
        vm.stopPrank();
    }

    // Test get price of listed NFT
    function testGetPrice() public {
        vm.startPrank(owner);
        nftMarketplace.mintNFT(owner);
        uint256 tokenId = 1;
        nftMarketplace.listNFT(tokenId, 1 ether);
        uint256 price = nftMarketplace.getPrice(tokenId);
        assertEq(price, 1 ether);
        vm.stopPrank();
    }

    // Test get price of unlisted NFT should revert
    function testGetPriceOfUnlistedNFT() public {
        vm.startPrank(owner);
        nftMarketplace.mintNFT(owner);
        uint256 tokenId = 1;
        vm.expectRevert(NFTMarketplace.NFTNotListedForSale.selector);
        nftMarketplace.getPrice(tokenId);
        vm.stopPrank();
    }
}
