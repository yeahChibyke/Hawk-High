// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.26;

import {Test, console2} from "forge-std/Test.sol";
import {DeployLevelOne} from "../script/DeployLevelOne.s.sol";
import {GraduateToLevelTwo} from "../script/GraduateToLevelTwo.s.sol";
import {LevelOne} from "../src/LevelOne.sol";
import {LevelTwo} from "../src/LevelTwo.sol";

contract LevelOneAndGraduateTest is Test {
    DeployLevelOne deployBot;
    GraduateToLevelTwo graduateBot;
    LevelOne proxy;
    LevelTwo implementation;

    address principal = address(0x1);
    // teachers
    address alice = address(0x2);
    address bob = address(0x3);
    // students
    address clara = address(0x4);
    address dan = address(0x5);
    address eli = address(0x6);
    address fin = address(0x7);
    address grey = address(0x8);
    address harriet = address(0x9);

    uint256 schoolFees = 1 ether;

    function setUp() public {
        deployBot = new DeployLevelOne();
        graduateBot = new GraduateToLevelTwo();

        proxy = LevelOne(payable(deployBot.run()));

        vm.deal(clara, 1 ether);
        vm.deal(dan, 1 ether);
        vm.deal(eli, 1 ether);
        vm.deal(fin, 1 ether);
        vm.deal(grey, 1 ether);
        vm.deal(harriet, 1 ether);
    }

    function test_confirm_deployment_is_level_one() public {
        address proxyAddress = deployBot.deployLevelOne();

        uint256 expected = 35;

        assert(expected == LevelOne(proxyAddress).TEACHER_WAGE());
    }
}
