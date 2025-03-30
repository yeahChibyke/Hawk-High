// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol";
import "@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol";
import "@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol";

contract Level1 is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    struct Student {
        string name;
        mapping(string => uint256) subjectScores;
        uint256 totalScore;
        bool exists;
    }
    
    mapping(address => Student) public students;
    mapping(address => bool) public teachers;
    uint256 public cutOffMark;
    address public principal;
    address public level2Contract;
    uint256 public schoolYearEnd;
    
    event StudentAdded(address indexed student, string name);
    event ScoreAssigned(address indexed student, string subject, uint256 score);
    event TeacherAdded(address indexed teacher);
    event UpgradedToLevel2(address indexed student);
    event SchoolYearStarted(uint256 startTime, uint256 endTime);

    modifier onlyPrincipal() {
        require(msg.sender == principal, "Not the principal");
        _;
    }

    modifier onlyTeacher() {
        require(teachers[msg.sender], "Not a teacher");
        _;
    }

    function initialize(address _principal, uint256 _cutOffMark) public initializer {
        __Ownable_init(msg.sender);
        __UUPSUpgradeable_init();
        principal = _principal;
        cutOffMark = _CutOffMark;
        startSchoolYear();
    }

    function _authorizeUpgrade(address newImplementation) internal override onlyOwner {}

    function startSchoolYear() public onlyPrincipal {
        schoolYearEnd = block.timestamp + 90 days;
        emit SchoolYearStarted(block.timestamp, schoolYearEnd);
    }

    function addStudent(address student, string memory name) external onlyPrincipal {
        require(!students[student].exists, "Student already exists");
        students[student].name = name;
        students[student].exists = true;
        emit StudentAdded(student, name);
    }

    function addTeacher(address teacher) external onlyPrincipal {
        teachers[teacher] = true;
        emit TeacherAdded(teacher);
    }

    function assignScore(address student, string memory subject, uint256 score) external onlyTeacher {
        require(students[student].exists, "Student not found");
        students[student].subjectScores[subject] = score;
        recalculateTotalScore(student);
        emit ScoreAssigned(student, subject, score);
    }

    function recalculateTotalScore(address student) internal {
        uint256 total = 0;
        for (string memory subject in students[student].subjectScores) {
            total += students[student].subjectScores[subject];
        }
        students[student].totalScore = total;
    }

    function upgradeStudents(address newLevel2) external onlyPrincipal {
        require(block.timestamp >= schoolYearEnd, "School year not yet over");
        level2Contract = newLevel2;
        for (address studentAddr in students) {
            if (students[studentAddr].totalScore >= cutOffMark) {
                Level2(level2Contract).enrollStudent(studentAddr, students[studentAddr].name);
                emit UpgradedToLevel2(studentAddr);
            }
        }
        startSchoolYear();
    }
}
