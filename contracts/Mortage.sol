pragma solidity ^0.8.0;

contract MortgageContract {
    address public owner;
    address public thirdPartyPlatform;
    address public leader;
    uint public usdtAmount;
    bool public contractInitiated;
    bool public ownerAgreed;
    bool public leaderSigned;
    bool public collateralTransferred;
    string public requirement;

    mapping(address => uint256) public ownerBalance;
    mapping(address => uint256) public thirdPartyPlatformBalance;
    mapping(address => uint256) public leaderBalance;

    event ContractInitiated(
        address indexed owner,
        address indexed thirdPartyPlatform,
        string indexed requirementAndAmount
    );
    event ContractApproved(address indexed owner, uint256 indexed usdtAmount);
    event Transfer(address indexed from, address indexed to, uint256 amount);
    event Escrowed(address indexed escrowAddress, address indexed escrowOwner);

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
        uint _usdtAmount,
        string memory _requirement
    ) {
        owner = _owner;
        thirdPartyPlatform = _thirdPartyPlatform;
        leader = _leader;
        usdtAmount = _usdtAmount;
        requirement = _requirement;
        contractInitiated = false;
        ownerAgreed = false;
        leaderSigned = false;
        collateralTransferred = false;
    }

    function initiateContract() external onlyThirdPartyPlatform {
        require(!contractInitiated, "Contract has already been initiated");

        string memory descriptionOfrequirment = string(
            abi.encodePacked("reauirment is : ", requirement)
        );
        string memory usdtAmount = string(
            abi.encodePacked("usdt amount is : ", usdtAmount)
        );
        string memory requirementAndAmount = string(
            abi.encodePacked(descriptionOfrequirment, usdtAmount)
        );

        emit ContractInitiated(owner, thirdPartyPlatform, requirementAndAmount); // 發送通知給業主以及第三方平台

        contractInitiated = true;
    }

    function transferCollateralToThridPartyPlatform() external onlyOwner {
        require(ownerAgreed, "Owner has not agreed to the contract");

        // 將抵押品轉移到第三方平台錢包
        emit ContractApproved();
    }

    function agreeToContract() external onlyOwner {
        require(contractInitiated, "Contract has not been initiated yet");
        ownerAgreed = true;
    }

    function requestLeaderSignature() external onlyOwner {
        require(ownerAgreed, "Owner has not agreed to the contract");
        require(!leaderSigned, "Leader has already signed the contract");
        // 請求 leader 簽名
        leaderSigned = true;
    }

    function transferCollateral() external onlyLeader {
        require(leaderSigned, "Leader has not signed the contract yet");
        // 檢查抵押品是否符合資格
        // 如果符合資格，則將抵押品轉移到第三方平台錢包
        // 否則，將抵押品退回給業主

        collateralTransferred = true; // 假設這裡成功地完成了抵押品的轉移
    }
}
