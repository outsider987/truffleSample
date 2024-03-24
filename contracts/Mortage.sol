// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract MortgageContract {
    address public owner;
    address public thirdPartyPlatform;
    address public leader;
    uint256 public owerUsdtAmount;
    uint public leaderUsdtAmount;
    bool public contractInitiated;
    bool public ownerAgreed;
    bool public leaderSigned;
    bool public collateralTransferred;
    string public requirement;
    uint public expirationTime;

    mapping(address => uint256) public ownerBalance;
    mapping(address => uint256) public thirdPartyPlatformBalance;
    mapping(address => uint256) public leaderBalance;

    event ContractInitiated(
        address indexed owner,
        address indexed thirdPartyPlatform,
        string indexed requirementAndAmount
    );
    event ContractApproved(
        address indexed owner,
        uint256 indexed owerUsdtAmount
    );
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Escrowed(address indexed escrowLeader, address indexed escrowOwner);
    event Signed(address indexed leader);

    modifier onlyOwner() {
        require(
            msg.sender == owner,
            "Only contract owner can call this function"
        );
        _;
    }

    modifier onlyLeader() {
        require(
            msg.sender == leader,
            "Only designated leader can call this function"
        );
        _;
    }

    modifier onlyThirdPartyPlatform() {
        require(
            msg.sender == thirdPartyPlatform,
            "Only third party platform can call this function"
        );
        _;
    }

    constructor() {
        thirdPartyPlatform = msg.sender;

        contractInitiated = false;
        ownerAgreed = false;
        leaderSigned = false;
        collateralTransferred = false;
    }

    function initiateContract(
        address _owner,
        string memory _requirement,
        uint256 _owerUsdtAmount,
        uint256 _expirationTime
    ) external payable onlyThirdPartyPlatform returns (string memory) {
        require(!contractInitiated, "Contract has already been initiated");
        // initiate contract var
        requirement = _requirement;
        expirationTime = _expirationTime;
        owerUsdtAmount = _owerUsdtAmount;

        owner = _owner;

        string memory descriptionOfrequirment = string(
            abi.encodePacked("reauirment is : ", requirement)
        );
        string memory owerUsdtAmountStr = string(
            abi.encodePacked("usdt amount is : ", owerUsdtAmount)
        );
        string memory requirementAndAmount = string(
            abi.encodePacked(descriptionOfrequirment, owerUsdtAmountStr)
        );

        emit ContractInitiated(owner, thirdPartyPlatform, requirementAndAmount); // 發送通知給業主以及第三方平台

        contractInitiated = true;
        return "initiate contract";
    }

    function transferCollateralToThridPartyPlatform(
        bool _isOnwerAgreed,
        address payable _thirdPartyPlatform
    ) public payable returns (bool) {
        require(_isOnwerAgreed, "Onwer need granted access ");

        ownerAgreed = _isOnwerAgreed;
        emit Transfer(msg.sender, _thirdPartyPlatform, msg.value);

        _thirdPartyPlatform.transfer(msg.value);
        

        emit ContractApproved(owner, msg.value);
        return true;
    }

    function requestLeaderSignature(
        bool _isLeaderAgreed,
        address _leader
    ) external onlyThirdPartyPlatform {
        require(ownerAgreed, "Owner has not agreed to the contract");
        require(!leaderSigned, "Leader has already signed");
        require(_isLeaderAgreed, "Leader need granted access ");

        leader = _leader;
        leaderSigned = _isLeaderAgreed;
        leaderUsdtAmount = owerUsdtAmount / 2;

        emit Escrowed(leader, owner);

        emit Transfer(leader, thirdPartyPlatform, leaderUsdtAmount);

        thirdPartyPlatformBalance[thirdPartyPlatform] += leaderUsdtAmount;
        leaderBalance[leader] -= leaderUsdtAmount;

        emit Signed(leader);
    }
}
