// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.26;

import {Script} from "forge-std/Script.sol";
import {LevelOne} from "../src/LevelOne.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
import {MockUSDC} from "../test/mocks/MockUSDC.sol";

contract DeployLevelOne is Script {
    address public principal = makeAddr("principal");
    uint256 public schoolFees = 1e18;
    MockUSDC usdc;

    function run() external returns (address proxy) {
        proxy = deployLevelOne();
        return proxy;
    }

    function deployLevelOne() public returns (address) {
        usdc = new MockUSDC();

        vm.startBroadcast();
        LevelOne levelOne = new LevelOne();
        ERC1967Proxy proxy = new ERC1967Proxy(address(levelOne), "");
        LevelOne(address(proxy)).initialize(principal, schoolFees, address(usdc));
        vm.stopBroadcast();

        return address(proxy);
    }

    function getUSDC() public view returns (MockUSDC) {
        return usdc;
    }
}
