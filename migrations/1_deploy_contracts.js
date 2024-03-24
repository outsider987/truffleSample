const ConvertLib = artifacts.require("ConvertLib");
const MetaCoin = artifacts.require("MetaCoin");
const ERC20 = artifacts.require("ERC20");
const MyToken = artifacts.require("MyToken");
const MortgageContract = artifacts.require("MortgageContract");

module.exports = function (deployer) {
  // deployer.deploy(ConvertLib);
  // deployer.link(ConvertLib, MetaCoin);
  // deployer.deploy(MyToken, "MyToken", "MTK", 18);
  deployer.deploy(MortgageContract);
};
