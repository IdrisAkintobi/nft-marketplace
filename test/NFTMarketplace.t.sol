// SPDX-License-Identifier: MIT
pragma solidity ^0.8.26;

import { Test, console } from "forge-std/Test.sol";
import { NFTMarketplace } from "../src/NFTMarketplace.sol";

contract CounterTest is Test {
    NFTMarketplace public nftMarketplace;

    function setUp() public {
        nftMarketplace = new NFTMarketplace();
    }

    function test_Increment() public { }

    function testFuzz_SetNumber(uint256 x) public { }
}
