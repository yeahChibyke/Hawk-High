// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.26;

import {Script} from "forge-std/Script.sol";
import {LevelTwo} from "../src/LevelTwo.sol";
import {LevelOne} from "../src/LevelOne.sol";
import {DevOpsTools} from "lib/foundry-devops/src/DevOpsTools.sol";

contract GraduateToLevelTwo is Script {
    function run() external returns (address proxy) {
        address mostRecentlyDeployed = DevOpsTools.get_most_recent_deployment("ERC1967Proxy", block.chainid);

        vm.startBroadcast();
        LevelTwo levelTwo = new LevelTwo();
        vm.stopBroadcast();

        proxy = graduateToLevelTwo(mostRecentlyDeployed, address(levelTwo));

        return proxy;
    }

    function graduateToLevelTwo(address _proxyAddress, address _levelTwo) public returns(address) {
        vm.startBroadcast();
        LevelOne proxy = LevelOne(payable(_proxyAddress));
        proxy.upgradeToAndCall(address(_levelTwo), "");
        vm.stopBroadcast();

        return address(proxy);
    }
}
