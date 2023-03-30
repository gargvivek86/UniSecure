// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./Courses.sol";

contract StudentRegistration is CoursesRegistration {
    struct Student {
        string firstName;
        string lastName;
        string gender;
        string fatherName;
        string dob;
        string emailId;
        string saddress;
        uint phoneNo;
        bool status;
    }

    mapping(address => Student) students;
    address[] studentList;

    function registerNewStudent(address _studentId, string memory _firstName, string memory _lastName, string memory _gender, string memory _fatherName, string memory _dob, string memory _emailId, string memory _address, uint _phoneNo) public {
        require(bytes(_firstName).length > 0 && bytes(_lastName).length > 0, "First name and last name are required");
        require(bytes(_emailId).length > 0, "Email ID is required");
        require(students[_studentId].phoneNo == 0, "Student already registered");
        students[_studentId] = Student(_firstName, _lastName, _gender, _fatherName, _dob, _emailId, _address, _phoneNo, true);
        studentList.push(_studentId);
         }

    function assignStudentToCourse(address _studentId, address _courseId) public {
        Courses[_courseId].students.push(_studentId);
    }

    function getStudentDetails(address _studentId) view public returns(Student memory _student) {
        require(students[_studentId].phoneNo > 0, "Student not registered");
        return students[_studentId];
    }

    function getOverallStudentList() view public returns(address[] memory){
        return studentList;
    }

    function getStudentListByCourse(address _courseId) view public returns(address[] memory){
        return Courses[_courseId].students;
    }
    function getStudentCountByCourse(address _courseId) view public returns(uint){
        return Courses[_courseId].students.length;
    }
    function updateStatusStudent(address _studentId, bool _status) public {
        students[_studentId].status=_status;
    }
}
