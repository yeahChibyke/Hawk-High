// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.26;

import {Script} from "forge-std/Script.sol";
import {LevelOne} from "../src/LevelOne.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";

contract DeployLevelOne is Script {
    function run() external returns (address proxy) {
        proxy = deployLevelOne();
        return proxy;
    }

    function deployLevelOne() public returns (address) {
        vm.startBroadcast();
        LevelOne levelOne = new LevelOne();
        ERC1967Proxy proxy = new ERC1967Proxy(address(levelOne), "");
        vm.stopBroadcast();

        return address(proxy);
    }
}
