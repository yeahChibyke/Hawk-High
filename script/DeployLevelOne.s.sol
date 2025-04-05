// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.26;

import {Script} from "forge-std/Script.sol";
import {LevelOne} from "../src/LevelOne.sol";
import {ERC1967Proxy} from "@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol";
// import {IERC20} from "@openzeppelin/contracts/token/ERC20/IERC20.sol";

contract DeployLevelOne is Script {
    address principal;
    // IERC20 weth;
    address weth;
    uint256 schoolFees;

    function run() external returns (address proxy) {
        proxy = deployLevelOne();
        return proxy;
    }

    function deployLevelOne() public returns (address) {
        vm.startBroadcast();
        LevelOne levelOne = new LevelOne();
        ERC1967Proxy proxy = new ERC1967Proxy(address(levelOne), "");
        LevelOne(address(proxy)).initialize(principal, schoolFees, weth);
        vm.stopBroadcast();

        return address(proxy);
    }
}
