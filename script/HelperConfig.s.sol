// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import { Script } from "forge-std/Script.sol";
import { MockV3Aggregator } from "../test/mocks/MockV3Aggregator.sol";

contract HelperConfig is Script {
    uint8 public constant DECIMALS = 8;
    int256 public constant INITAL_PRICE = 2000e8;
    struct NetWorkConfig {
        address priceFeed;
    }
    NetWorkConfig public activeNetworkConfig;
    constructor() {
        if(block.chainid == 11155111) {
            activeNetworkConfig = getSepoliaEthConfig();
        } else {
            activeNetworkConfig = getOrCreateAnvilEthConfig();
        }
    }

    function getSepoliaEthConfig() public pure returns(NetWorkConfig memory) {
        // https://docs.chain.link/data-feeds/price-feeds/addresses?network=ethereum&page=1
        NetWorkConfig memory ethConfig = NetWorkConfig({
            priceFeed: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        });
        return ethConfig;
    }

    function getOrCreateAnvilEthConfig() public returns(NetWorkConfig memory) {
        if(activeNetworkConfig.priceFeed != address(0)) {
            return activeNetworkConfig;
        }

        vm.startBroadcast();
        MockV3Aggregator mockPriceFeed = new MockV3Aggregator(DECIMALS, INITAL_PRICE);
        vm.stopBroadcast();
        NetWorkConfig memory ethConfig = NetWorkConfig({
            priceFeed: address(mockPriceFeed)
        });
        return ethConfig;
    }
}