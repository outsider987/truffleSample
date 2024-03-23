pragma solidity ^0.8.0;

contract MortgageContract {
    address public owner;
    address public thirdPartyPlatform;
    address public leader;
    uint public owerUsdtAmount;
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

    constructor(
        address _owner,
        address _thirdPartyPlatform,
        address _leader,
        uint _owerUsdtAmount,
        string memory _requirement,
        uint _expirationTime
    ) {
        owner = _owner;
        thirdPartyPlatform = _thirdPartyPlatform;
        leader = _leader;
        owerUsdtAmount = _owerUsdtAmount;
        leaderUsdtAmount = _owerUsdtAmount / 2;
        requirement = _requirement;
        contractInitiated = false;
        ownerAgreed = false;
        leaderSigned = false;
        collateralTransferred = false;
        expirationTime = _expirationTime;
    }

    function initiateContract() external onlyThirdPartyPlatform {
        require(!contractInitiated, "Contract has already been initiated");

        string memory descriptionOfrequirment = string(
            abi.encodePacked("reauirment is : ", requirement)
        );
        string memory owerUsdtAmount = string(
            abi.encodePacked("usdt amount is : ", owerUsdtAmount)
        );
        string memory requirementAndAmount = string(
            abi.encodePacked(descriptionOfrequirment, owerUsdtAmount)
        );

        emit ContractInitiated(owner, thirdPartyPlatform, requirementAndAmount); // 發送通知給業主以及第三方平台

        contractInitiated = true;
    }

    function transferCollateralToThridPartyPlatform(
        bool _isOnwerAgreed
    ) external onlyOwner {
        require(_isOnwerAgreed, "Onwer need granted access ");
        ownerAgreed = _isOnwerAgreed;
        emit Transfer(owner, thirdPartyPlatform, owerUsdtAmount);

        thirdPartyPlatformBalance[thirdPartyPlatform] += owerUsdtAmount;

        ownerBalance[owner] -= owerUsdtAmount;

        owerUsdtAmount = 0;

        emit ContractApproved(owner, owerUsdtAmount);
    }

    function requestLeaderSignature(
        bool _isLeaderAgreed
    ) external onlyThirdPartyPlatform {
        require(ownerAgreed, "Owner has not agreed to the contract");
        require(!leaderSigned, "Leader has already signed");
        require(_isLeaderAgreed, "Leader need granted access ");

        leaderSigned = _isLeaderAgreed;
        emit Escrowed(leader, owner);

        emit Transfer(leader, thirdPartyPlatform, leaderUsdtAmount);

        thirdPartyPlatformBalance[thirdPartyPlatform] += leaderUsdtAmount;
        leaderBalance[leader] -= leaderUsdtAmount;

        leaderUsdtAmount = 0;
        emit Signed(leader);
    }
}
