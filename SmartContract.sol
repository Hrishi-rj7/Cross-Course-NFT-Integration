// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract CourseNFT {
    uint256 public tokenCounter;
    address public owner;

    // Mapping from token ID to owner
    mapping(uint256 => address) private tokenOwners;

    // Mapping from token ID to token URI (metadata)
    mapping(uint256 => string) private tokenURIs;

    // Mapping from course ID to NFT status (whether the course content is unlocked)
    mapping(uint256 => mapping(address => bool)) public courseUnlocked;

    // Mapping from course ID to certificate URI
    mapping(uint256 => string) private certificateURIs;

    // Event to emit when a course is unlocked
    event CourseUnlocked(uint256 courseId, address indexed user);

    // Event to emit when a certificate is issued
    event CertificateIssued(uint256 courseId, address indexed student, string certificateURI);

    constructor() {
        tokenCounter = 0;
        owner = msg.sender;
    }

    modifier onlyOwner() {
        require(msg.sender == owner, "Only owner can call this function");
        _;
    }

    modifier onlyTokenOwner(uint256 tokenId) {
        require(tokenOwners[tokenId] == msg.sender, "You must own the NFT to perform this action");
        _;
    }

    // Function to mint an NFT upon course completion
    function mintNFT(address student, string memory uri) public onlyOwner returns (uint256) {
        uint256 newItemId = tokenCounter;
        tokenOwners[newItemId] = student;
        tokenURIs[newItemId] = uri;
        tokenCounter += 1;
        return newItemId;
    }

    // Function to issue a certificate upon course completion
    function issueCertificate(uint256 courseId, address student, string memory certificateURI) public onlyOwner {
        certificateURIs[courseId] = certificateURI;
        emit CertificateIssued(courseId, student, certificateURI);
    }

    // Function to unlock course content using a specific NFT
    function unlockCourse(uint256 courseId, uint256 tokenId) public onlyTokenOwner(tokenId) {
        require(!courseUnlocked[courseId][msg.sender], "Course already unlocked");

        courseUnlocked[courseId][msg.sender] = true;
        emit CourseUnlocked(courseId, msg.sender);
    }

    // Function to check if a course is unlocked for a user
    function isCourseUnlocked(uint256 courseId, address user) public view returns (bool) {
        return courseUnlocked[courseId][user];
    }

    // Function to get the owner of a specific token
    function ownerOf(uint256 tokenId) public view returns (address) {
        return tokenOwners[tokenId];
    }

    // Function to get the token URI (metadata) of a specific token
    function tokenURI(uint256 tokenId) public view returns (string memory) {
        return tokenURIs[tokenId];
    }

    // Function to get the certificate URI for a specific course
    function getCertificateURI(uint256 courseId) public view returns (string memory) {
        return certificateURIs[courseId];
    }
}