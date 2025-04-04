// // SPDX-License-Identifier: SEE LICENSE IN LICENSE
// pragma solidity 0.8.26;

// import {Test, console2} from "forge-std/Test.sol";
// import {LevelOne} from "../src/LevelOne.sol";

// contract TestLevelOne is Test {
//     LevelOne levelOne;

//     address principal = address(0x1);
//     // teachers
//     address alice = address(0x2);
//     address bob = address(0x3);
//     // students
//     address clara = address(0x4);
//     address dan = address(0x5);
//     address eli = address(0x6);
//     address fin = address(0x7);
//     address grey = address(0x8);
//     address harriet = address(0x9);

//     uint256 schoolFees = 1 ether;

//     function setUp() public {
//         levelOne = new LevelOne(principal, schoolFees);

//         vm.startPrank(principal);
//         levelOne.addTeacher(alice);
//         levelOne.addTeacher(bob);
//         vm.stopPrank();

//         vm.deal(clara, 1 ether);
//         vm.deal(dan, 1 ether);
//         vm.deal(eli, 1 ether);
//         vm.deal(fin, 1 ether);
//         vm.deal(grey, 1 ether);
//         vm.deal(harriet, 1 ether);
//     }

//     function test_confirm_teachers_added() public view {
//         assert(levelOne.isTeacher(alice) == true);
//         assert(levelOne.isTeacher(bob) == true);
//     }

//     function test_confirm_only_principal_can_add_teacher() public {
//         address teacher = makeAddr("teacher");

//         vm.expectRevert(LevelOne.HH__NotPrincipal.selector);
//         levelOne.addTeacher(teacher);
//     }

//     function test_confirm_only_principal_can_remove_teacher() public {
//         vm.expectRevert(LevelOne.HH__NotPrincipal.selector);
//         levelOne.removeTeacher(alice);

//         assert(levelOne.isTeacher(alice) == true);

//         vm.prank(principal);
//         levelOne.removeTeacher(alice);

//         assert(levelOne.isTeacher(alice) == false);
//     }

//     function test_confirm_enroll() public {
//         assert(levelOne.isStudent(clara) == false);

//         vm.prank(clara);
//         levelOne.enroll{value: schoolFees}();

//         assert(levelOne.isStudent(clara) == true);
//         assert(levelOne.studentScore(clara) == 100);
//         assert(levelOne.bursary() == 1 ether);
//     }

//     modifier sessionStarted() {
//         vm.prank(clara);
//         levelOne.enroll{value: schoolFees}();

//         vm.prank(dan);
//         levelOne.enroll{value: schoolFees}();

//         vm.prank(eli);
//         levelOne.enroll{value: schoolFees}();

//         vm.prank(fin);
//         levelOne.enroll{value: schoolFees}();

//         vm.prank(grey);
//         levelOne.enroll{value: schoolFees}();

//         vm.prank(harriet);
//         levelOne.enroll{value: schoolFees}();

//         vm.prank(principal);
//         levelOne.startSession(70);
//         _;
//     }

//     function test_confirm_no_enroll_when_in_session() public sessionStarted {
//         address student = makeAddr("student");
//         vm.deal(student, 1 ether);

//         vm.prank(student);
//         vm.expectRevert(LevelOne.HH__AlreadyInSession.selector);
//         levelOne.enroll{value: 1 ether}();
//     }

//     function test_confirm_no_add_teacher_when_in_session() public sessionStarted {
//         address teacher = makeAddr("teacher");

//         vm.prank(principal);
//         vm.expectRevert(LevelOne.HH__AlreadyInSession.selector);
//         levelOne.addTeacher(teacher);
//     }

//     function test_confirm_no_expel_when_not_in_session() public {
//         vm.prank(grey);
//         levelOne.enroll{value: 1 ether}();

//         vm.prank(principal);
//         vm.expectRevert();
//         levelOne.expel(grey);
//     }

//     function test_confirm_can_give_review() public sessionStarted {
//         vm.warp(1 weeks);

//         vm.prank(alice);
//         levelOne.giveReview(fin, false);

//         assert(levelOne.studentScore(fin) == 90);
//     }
// }
