// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity 0.8.26;

import {Test, console2} from "forge-std/Test.sol";
import {DeployLevelOne} from "../script/DeployLevelOne.s.sol";
import {GraduateToLevelTwo} from "../script/GraduateToLevelTwo.s.sol";
import {LevelOne} from "../src/LevelOne.sol";
import {LevelTwo} from "../src/LevelTwo.sol";
import {MockUSDC} from "./mocks/MockUSDC.sol";

contract LevelOneAndGraduateTest is Test {
    DeployLevelOne deployBot;
    GraduateToLevelTwo graduateBot;
    LevelOne proxy;
    LevelTwo implementation;

    MockUSDC usdc;

    address principal;
    // teachers
    address alice;
    address bob;
    // students
    address clara;
    address dan;
    address eli;
    address fin;
    address grey;
    address harriet;

    uint256 schoolFees = 1 ether;

    function setUp() public {
        deployBot = new DeployLevelOne();
        graduateBot = new GraduateToLevelTwo();

        proxy = LevelOne(deployBot.run());

        usdc = deployBot.getUSDC();

        alice = makeAddr("first_teacher");
        bob = makeAddr("second_teacher");

        clara = makeAddr("first_student");
        dan = makeAddr("second_student");
        eli = makeAddr("third_student");
        fin = makeAddr("fourth_student");
        grey = makeAddr("fifth_student");
        harriet = makeAddr("sixth_student");

        usdc.mint(clara, 1e18);
        usdc.mint(dan, 1e18);
        usdc.mint(eli, 1e18);
        usdc.mint(fin, 1e18);
        usdc.mint(grey, 1e18);
        usdc.mint(harriet, 1e18);

        principal = makeAddr("principal");
        principal = deployBot.principal();
    }

    function test_confirm_deployment_is_level_one() public {
        address proxyAddress = deployBot.deployLevelOne();

        uint256 expectedTeacherWage = 35;
        uint256 expectedPrincipalWage = 5;
        uint256 expectedPrecision = 100;

        assert(expectedTeacherWage == LevelOne(proxyAddress).TEACHER_WAGE());
        assert(expectedPrincipalWage == LevelOne(proxyAddress).PRINCIPAL_WAGE());
        assert(expectedPrecision == LevelOne(proxyAddress).PRECISION());
        assert(principal == LevelOne(proxyAddress).getPrincipal());
        assert(deployBot.schoolFees() == LevelOne(proxyAddress).getSchoolFeesCost());
        // assert(address(usdc) == LevelOne(proxyAddress).getSchoolFeesToken()); //--> This assert keeps failing. It is making it impossible to test the enroll funtion as I cannot grant appropriate approval
        assert(address(deployBot.getUSDC()) == LevelOne(proxyAddress).getSchoolFeesToken());
    }

    function test_confirm_add_teacher() public {
        address proxyAddress = deployBot.deployLevelOne();

        vm.startPrank(principal);
        LevelOne(proxyAddress).addTeacher(alice);
        LevelOne(proxyAddress).addTeacher(bob);
        vm.stopPrank();

        assert(LevelOne(proxyAddress).isTeacher(alice) == true);
        assert(LevelOne(proxyAddress).isTeacher(bob) == true);
        assert(LevelOne(proxyAddress).getTotalTeachers() == 2);

        // console2.log(usdc.balanceOf(clara));
    }

    function test_confirm_enroll() public {
        address proxyAddress = deployBot.deployLevelOne();

        vm.prank(clara);
        LevelOne(proxyAddress).enroll();
    }
}
