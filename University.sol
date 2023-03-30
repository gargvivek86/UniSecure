// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;


contract UniversityRegistartion {

    struct University {
        string name;
        string licenseNo;
        string emailId;
        string saddress;
        uint phoneNo;
        string location;
        bool status;
        address[] courses;
    }
    
    mapping(address => University) Universities;
    address[] universityList;
    
    
    function registerNewUniversity(address _universityid, string memory _name, string memory _licenseNo, string memory _emailId, string memory _address, uint _phoneNo, string memory _location, bool _status) public {
        Universities[_universityid] = University(_name, _licenseNo, _emailId, _address, _phoneNo, _location, _status,new address[] (0));
        universityList.push(_universityid);
    }


    function getUniversityDetails(address _universityid) view public returns(University memory) {
        return Universities[_universityid];
    }

    function getUniversityList() view public returns(address[] memory){
        return universityList;
    }
}