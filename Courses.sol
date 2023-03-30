// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "./University.sol";

contract CoursesRegistration is UniversityRegistartion {

    struct Course {
        string name;
        string courseType;
        uint8 duration; // in years
        string description;
        string courseCode;
        string level;
        uint8 rating;
        bool status;
        address[] students;
    }
    
    mapping(address => Course) Courses;
    
    function registerNewCourse(address _Courseid, string memory _name, string memory _type, uint8 _duration, string memory _description, string memory _code, string memory _level, uint8 _rating) public {
        require(bytes(_name).length > 0 && bytes(_type).length > 0, "Couse name and type are required");
        Courses[_Courseid] = Course(_name, _type, _duration, _description, _code,_level, _rating, true, new address[] (0));  
    }

    function assignCourseToUniversity(address _universityId, address _courseId) public {
        Universities[_universityId].courses.push(_courseId);
    }

    function getCourseDetails(address _Courseid) view public returns(Course memory) {
        return Courses[_Courseid];
    }

    function getCourseListForUniversity(address _universityid) view public returns (address[] memory) {
        return Universities[_universityid].courses;
    }
    
    function getCourseCountForUniversity(address _universityid) view public returns (uint) {
        return Universities[_universityid].courses.length;
    }

    function updateStatusCourse(address _Courseid, bool _status) public {
        Courses[_Courseid].status=_status;
    }
}