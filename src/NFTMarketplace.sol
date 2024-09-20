// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

contract NFTMarketplace is ERC721 {
    address owner;
    uint256 private tokenIdCounter;

    struct NFTSale {
        uint256 price;
        address seller;
        bool isListed;
    }

    // Mapping of tokenId to sale info
    mapping(uint256 => NFTSale) public nftSales;

    // Events
    event NFTMinted(uint256 indexed tokenId, address indexed owner);
    event NFTListed(uint256 indexed tokenId, uint256 price, address indexed seller);
    event NFTSold(uint256 indexed tokenId, uint256 price, address indexed buyer, address indexed seller);

    // Errors
    error OnlyOwnerCanPerformThisAction();
    error NotTokenOwner();
    error PriceMustBeGreaterThanZero();
    error NFTNotListedForSale();
    error InsufficientFunds();
    error CannotTransferListedNFT();
    error AddressZeroDetected();

    // Modifier
    modifier onlyOwner() {
        if (msg.sender != owner) revert OnlyOwnerCanPerformThisAction();
        _;
    }

    constructor() ERC721("NFTMarketplaceToken", "NMT") {
        owner = msg.sender;
    }

    // Function to mint new NFTs
    function mintNFT(address to) public onlyOwner {
        uint256 tokenId = ++tokenIdCounter;
        _safeMint(to, tokenId);
        emit NFTMinted(tokenId, to);
    }

    // Function to list an NFT for sale
    function listNFT(uint256 tokenId, uint256 price) public {
        if (ownerOf(tokenId) != msg.sender) revert NotTokenOwner();
        if (price <= 0) revert PriceMustBeGreaterThanZero();

        nftSales[tokenId] = NFTSale({ price: price, seller: msg.sender, isListed: true });

        emit NFTListed(tokenId, price, msg.sender);
    }

    // Function to buy an NFT
    function buyNFT(uint256 tokenId) public payable {
        NFTSale memory sale = nftSales[tokenId];
        if (!sale.isListed) revert NFTNotListedForSale();
        if (msg.value < sale.price) revert InsufficientFunds();

        address seller = sale.seller;
        _safeTransfer(seller, msg.sender, tokenId);

        // Transfer funds to seller
        payable(seller).transfer(sale.price);

        // Mark as no longer listed
        nftSales[tokenId].isListed = false;

        emit NFTSold(tokenId, sale.price, msg.sender, seller);
    }

    function transferNFT(address to, uint256 tokenId) public {
        if (to == address(0)) revert AddressZeroDetected();
        if (ownerOf(tokenId) != msg.sender) revert NotTokenOwner();
        if (nftSales[tokenId].isListed) revert CannotTransferListedNFT();

        _safeTransfer(msg.sender, to, tokenId);
    }

    // Function to get the price of an NFT
    function getPrice(uint256 tokenId) public view returns (uint256) {
        if (!nftSales[tokenId].isListed) revert NFTNotListedForSale();
        return nftSales[tokenId].price;
    }
}
