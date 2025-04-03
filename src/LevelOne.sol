// SPDX-License-Identifier: MIT
pragma solidity 0.8.26;

// import "@openzeppelin/contracts/access/Ownable.sol";

contract LevelOne {
    error HH__NotPrincipal();
    error HH__NotPrincipalOrTeacher();
    error HH__ZeroAddress();
    error HH__TeacherExists();
    error HH__StudentExists();

    address principal;
    mapping(address => bool) private isTeacher;
    mapping(address => bool) private isStudent;

    event TeacherAdded(address indexed);
    event TeacherRemoved(address indexed);
    event Enrolled(address indexed);
    event Expelled(address indexed);

    constructor(address _principal) {
        principal = _principal;
    }

    modifier onlyPrincipal() {
        if (msg.sender == principal) {
            revert HH__NotPrincipal();
        }
        _;
    }

    modifier onlyStaff() {
        if (msg.sender == principal || !isTeacher[msg.sender]) {
            revert HH__NotPrincipalOrTeacher();
        }
        _;
    }

    function addTeacher(address _teacher) public onlyPrincipal {
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

    function enroll() external {
        require(!isTeacher[msg.sender] && msg.sender != principal);

        if (isStudent[msg.sender]) {
            revert HH__StudentExists();
        }

        isStudent[msg.sender] = true;

        emit Enrolled(msg.sender);
    }

    function expell(address _student) public onlyPrincipal {
        if (_student == address(0)) {
            revert HH__ZeroAddress();
        }

        require(isStudent[_student], "Student does not exist!!!");

        isStudent[_student] = false;
    }
}
