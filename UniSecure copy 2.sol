// SPDX-License-Identifier: MIT
pragma solidity ^0.8.4;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721URIStorage.sol";
import "./student.sol";

contract UniSecure is ERC721, ERC721URIStorage, StudentRegistration {
   
    address owner;
    modifier onlyOwner() {
        require(msg.sender == owner, "Only the owner can access this function.");
        _;
    }
    struct CertificateData {
        address course;
        string issueDate;
        string passingYear;
        address student;
        address university;
        string grade;
        string marks;
        bool studentSigned;
        uint studentSignedDate;
        bool universitySigned;
        uint universitySignedDate;
        bool certificateValidated;
    }
    
    struct AccessStatus {
        address _identity;
        string status;
    }
    mapping (bytes32 => AccessStatus[]) userAccessStatus;
    mapping (bytes32 => CertificateData) public certificates;
    mapping (address => bytes32[]) studentcertificates;
    event NewCertificateAdded(bytes32 indexed certificateHash);
    constructor() ERC721("UniSecure", "CERT") {
        owner = msg.sender;
    }
    
    function addCertificate(address _course, string memory uri, string memory _issuedate, string memory _passingYear, address _student, address _university, string memory _grade, string memory _marks) public onlyOwner returns (bytes32)  {
        bytes32 certificatehash= generateHash(_course);
        CertificateData memory certemp= CertificateData(_course, _issuedate, _passingYear, _student, _university, _grade, _marks, false,0 , false, 0, false);
        certificates[certificatehash] = certemp;
        studentcertificates[_student].push(certificatehash);
        userAccessStatus[certificatehash].push(AccessStatus(_student,"Allowed"));
        userAccessStatus[certificatehash].push(AccessStatus(_university,"Allowed"));
        _safeMint(msg.sender, uint256(certificatehash));
        _setTokenURI(uint256(certificatehash),uri);
        safeTransferFrom(msg.sender,_student,uint256(certificatehash));
        emit NewCertificateAdded(certificatehash);
        return certificatehash;
    }

    function _burn(uint256 tokenId) internal override (ERC721, ERC721URIStorage){
        super._burn(tokenId);
    }

    function tokenURI(uint256 tokenid) public view override(ERC721, ERC721URIStorage) returns(string memory){
        return super.tokenURI(tokenid);
    }
    
    function signCertificateByStudent(bytes32 _certificateHash) public {
        require(msg.sender == certificates[_certificateHash].student, "Only the student can sign this certificate");
        certificates[_certificateHash].studentSigned = true;
        certificates[_certificateHash].studentSignedDate=block.timestamp;
    }

        
    function attestCertificateByUniversity(bytes32 _certificateHash) public {
        require(msg.sender == certificates[_certificateHash].university, "Only the university can attest this certificate");
        require(certificates[_certificateHash].studentSigned == true, "The certificate must be signed by the student first");
        certificates[_certificateHash].universitySigned = true;
        certificates[_certificateHash].certificateValidated = true;
        certificates[_certificateHash].universitySignedDate = block.timestamp;
    }

function getCertificatesByStudent(address _student) public view returns (bytes32[] memory) {
    return studentcertificates[_student];
}


    function downloadCertificate(address _caller, bytes32 _certificatehash) public view returns (CertificateData memory) {
    AccessStatus[] storage accessStatus = userAccessStatus[_certificatehash];
    AccessStatus memory status;
    bool hasAccess = false;
    for (uint i = 0; i < accessStatus.length; i++) {
        if (keccak256(abi.encodePacked(accessStatus[i].status)) == keccak256(abi.encodePacked("Allowed")) && accessStatus[i]._identity == _caller) {
            status = accessStatus[i];
            hasAccess = true;
            break;
        }
    }
    if (hasAccess) {
        return certificates[_certificatehash];
    } else {
        revert("Access not allowed.");
    }
    }

     
    function isCertificateValid(bytes32 _certificatehash) public view returns (bool) {
        return certificates[_certificatehash].certificateValidated;
    }

    function requestPermission(address _caller, bytes32 _certificatehas) public {
        userAccessStatus[_certificatehas].push(AccessStatus(_caller,"Pending"));
    }

    function getListOfPendingRequests(bytes32 _cert) public view returns (AccessStatus[] memory) {
        require(ownerOf(uint256(_cert)) == msg.sender, " Only Certificate Owner can call this");
        return userAccessStatus[_cert];
    }

    function approvePermission(address _caller, bytes32 _certificatehas) public {
        require(ownerOf(uint256(_certificatehas)) == msg.sender, " Only Certificate Owner can call this");
        userAccessStatus[_certificatehas].push(AccessStatus(_caller,"Allowed"));
    }

    function generateHash(address course) public view returns (bytes32) {
        uint256 timestamp = block.timestamp;
        bytes32 hash = keccak256(abi.encodePacked(course, timestamp));
        return hash;
}
}