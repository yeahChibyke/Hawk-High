// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

import {LevelOne} from "./LevelOne.sol";

contract LevelTwo is LevelOne {
    address[] private graduatedStudents;
    address[] private graduatedTeachers;
    uint256 private newBursary;

    function graduatedState(
        address[] memory _graduatedStudents,
        address[] memory _graduatedTeachers,
        uint256 _newBursary
    ) external onlyPrincipal {
        for (uint256 n = 0; n < _graduatedStudents.length; n++) {
            if (studentScore[_graduatedStudents[n]] >= cutOffScore) {
                graduatedStudents.push(_graduatedStudents[n]);
            }
        }

        for (uint256 n = 0; n < _graduatedTeachers.length; n++) {
            if (isTeacher[_graduatedTeachers[n]]) {
                graduatedTeachers.push(_graduatedTeachers[n]);
            }
        }

        newBursary = _newBursary;
    }

    function getGraduatedStudents() external view returns (address[] memory) {
        return graduatedStudents;
    }

    function getGraduatedTeachers() external view returns (address[] memory) {
        return graduatedTeachers;
    }

    function getNewBursary() external view returns (uint256) {
        return newBursary;
    }
}
