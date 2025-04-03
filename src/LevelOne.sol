// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Hawk High First Flight
 * @author Chukwubuike Victory Chime @yeahChibyke
 * @notice Contract for the Hawk High School
 */
contract LevelOne {
    error HH__NotPrincipal();
    error HH__NotTeacher();
    error HH__ZeroAddress();
    error HH__TeacherExists();
    error HH__StudentExists();

    address principal;
    mapping(address => bool) private isTeacher;
    mapping(address => bool) private isStudent;
    mapping(address => uint256) private studentScore;
    mapping(address => uint256) private reviewCount;
    mapping(address => uint256) private lastReviewTime;
    uint256 public schoolFees;
    uint256 public immutable reviewTime = 1 weeks;
    bool inSession;
    uint256 public sessionEnd;
    uint256 public bursary;

    event TeacherAdded(address indexed);
    event TeacherRemoved(address indexed);
    event Enrolled(address indexed);
    event Expelled(address indexed);
    event SchoolInSession(uint256 indexed startTime, uint256 indexed endTime, uint256 indexed schoolFees);
    event ReviewGiven(address indexed student, bool indexed review, uint256 indexed studentScore);

    constructor(address _principal) {
        principal = _principal;
    }

    modifier onlyPrincipal() {
        if (msg.sender == principal) {
            revert HH__NotPrincipal();
        }
        _;
    }

    modifier onlyTeacher() {
        if (!isTeacher[msg.sender]) {
            revert HH__NotTeacher();
        }
        _;
    }

    modifier notYetInSession() {
        require(!inSession, "Hawk High is already in session!!!");
        _;
    }

    function addTeacher(address _teacher) public onlyPrincipal notYetInSession {
        if (_teacher == address(0)) {
            revert HH__ZeroAddress();
        }

        if (isTeacher[_teacher]) {
            revert HH__TeacherExists();
        }

        require(!isStudent[_teacher], "Cannot be a teacher and a student!!!");

        isTeacher[_teacher] = true;

        emit TeacherAdded(_teacher);
    }

    function removeTeacher(address _teacher) public onlyPrincipal {
        if (_teacher == address(0)) {
            revert HH__ZeroAddress();
        }

        require(isTeacher[_teacher], "Teacher does not exist!!!");

        isTeacher[_teacher] = false;

        emit TeacherRemoved(_teacher);
    }

    function enroll() external payable notYetInSession {
        require(!isTeacher[msg.sender] && msg.sender != principal);
        require(msg.value == schoolFees, "Hawk High fees not paid!!!");

        if (isStudent[msg.sender]) {
            revert HH__StudentExists();
        }

        isStudent[msg.sender] = true;
        studentScore[msg.sender] = 100;
        bursary += msg.value;

        emit Enrolled(msg.sender);
    }

    function expell(address _student) public onlyPrincipal {
        if (_student == address(0)) {
            revert HH__ZeroAddress();
        }

        require(isStudent[_student], "Student does not exist!!!");

        isStudent[_student] = false;
    }

    function startSession(uint256 _amount) public onlyPrincipal notYetInSession {
        if (_amount == 0) {
            revert HH__ZeroAddress();
        }
        sessionEnd = block.timestamp + 4 weeks;
        inSession = true;

        schoolFees = _amount;

        emit SchoolInSession(block.timestamp, sessionEnd, schoolFees);
    }

    function giveReview(address _student, bool review) public onlyTeacher {
        require(reviewCount[_student] < 5, "Student review count exceeded!!!");
        require(isStudent[_student], "Student does not exist!!!");
        require(block.timestamp >= lastReviewTime[_student] + reviewTime, "Reviews can only be given once per week");

        // where `false` is a bad review and true is a good review
        if (!review) {
            studentScore[_student] -= 10;
        }

        // Update last review time
        lastReviewTime[_student] = block.timestamp;

        emit ReviewGiven(_student, review, studentScore[_student]);
    }

    receive() external payable {}
}
