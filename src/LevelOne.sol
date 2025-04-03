// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// import "@openzeppelin/contracts/access/Ownable.sol";

/**
 * @title Hawk High First Flight
 * @author Chukwubuike Victory Chime @yeahChibyke
 * @notice Contract for the Hawk High School
 */
contract LevelOne {
    address principal;
    uint256 public schoolFees;
    uint256 public immutable reviewTime = 1 weeks;
    uint256 public sessionEnd;
    uint256 public bursary;
    mapping(address => bool) public isTeacher;
    mapping(address => bool) public isStudent;
    mapping(address => uint256) public studentScore;
    mapping(address => uint256) private reviewCount;
    mapping(address => uint256) private lastReviewTime;
    bool inSession;

    event TeacherAdded(address indexed);
    event TeacherRemoved(address indexed);
    event Enrolled(address indexed);
    event Expelled(address indexed);
    event SchoolInSession(uint256 indexed startTime, uint256 indexed endTime);
    event ReviewGiven(address indexed student, bool indexed review, uint256 indexed studentScore);

    error HH__NotPrincipal();
    error HH__NotTeacher();
    error HH__ZeroAddress();
    error HH__TeacherExists();
    error HH__StudentExists();
    error HH__TeacherDoesNotExist();
    error HH__StudentDoesNotExist();
    error HH__AlreadyInSession();
    error HH__ZeroValue();
    error HH__HawkHighFeesNotPaid();
    error HH__NotAllowed();

    modifier onlyPrincipal() {
        if (msg.sender != principal) {
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
        if (inSession == true) {
            revert HH__AlreadyInSession();
        }
        _;
    }

    constructor(address _principal, uint256 _schoolFees) {
        if (_principal == address(0)) {
            revert HH__ZeroAddress();
        }
        if (_schoolFees == 0) {
            revert HH__ZeroValue();
        }
        principal = _principal;
        schoolFees = _schoolFees;
    }

    receive() external payable {}

    function enroll() external payable notYetInSession {
        if (isTeacher[msg.sender] || msg.sender == principal) {
            revert HH__NotAllowed();
        }
        if (msg.value != schoolFees) {
            revert HH__HawkHighFeesNotPaid();
        }

        if (isStudent[msg.sender]) {
            revert HH__StudentExists();
        }

        isStudent[msg.sender] = true;
        studentScore[msg.sender] = 100;
        bursary += msg.value;

        emit Enrolled(msg.sender);
    }

    function addTeacher(address _teacher) public onlyPrincipal notYetInSession {
        if (_teacher == address(0)) {
            revert HH__ZeroAddress();
        }

        if (isTeacher[_teacher]) {
            revert HH__TeacherExists();
        }

        if (isStudent[_teacher]) {
            revert HH__NotAllowed();
        }

        isTeacher[_teacher] = true;

        emit TeacherAdded(_teacher);
    }

    function removeTeacher(address _teacher) public onlyPrincipal {
        if (_teacher == address(0)) {
            revert HH__ZeroAddress();
        }

        if (!isTeacher[_teacher]) {
            revert HH__TeacherDoesNotExist();
        }

        isTeacher[_teacher] = false;

        emit TeacherRemoved(_teacher);
    }

    function expel(address _student) public onlyPrincipal {
        if (inSession == false) {
            revert();
        }
        if (_student == address(0)) {
            revert HH__ZeroAddress();
        }

        if (!isStudent[_student]) {
            revert HH__StudentDoesNotExist();
        }

        isStudent[_student] = false;

        emit Expelled(_student);
    }

    function startSession() public onlyPrincipal notYetInSession {
        sessionEnd = block.timestamp + 4 weeks;
        inSession = true;

        emit SchoolInSession(block.timestamp, sessionEnd);
    }

    function giveReview(address _student, bool review) public onlyTeacher {
        if (!isStudent[_student]) {
            revert HH__StudentDoesNotExist();
        }
        require(reviewCount[_student] < 5, "Student review count exceeded!!!");
        require(block.timestamp >= lastReviewTime[_student] + reviewTime, "Reviews can only be given once per week");

        // where `false` is a bad review and true is a good review
        if (!review) {
            studentScore[_student] -= 10;
        }

        // Update last review time
        lastReviewTime[_student] = block.timestamp;

        emit ReviewGiven(_student, review, studentScore[_student]);
    }
}
