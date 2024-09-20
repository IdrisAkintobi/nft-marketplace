// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import { Script, console } from "forge-std/Script.sol";
import { NFTMarketplace } from "../src/NFTMarketplace.sol";

contract NFTMarketplaceScript is Script {
    NFTMarketplace public nftMarketplace;

    function setUp() public { }

    function run() public {
        vm.startBroadcast(vm.envUint("DO_NOT_LEAK"));
        // Deploy the contract
        nftMarketplace = new NFTMarketplace();
        // Stop broadcasting
        vm.stopBroadcast();

        console.log("AreaCalculator deployed to:", address(nftMarketplace));
    }
}
