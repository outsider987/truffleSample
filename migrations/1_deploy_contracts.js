const ConvertLib = artifacts.require("ConvertLib");
const MetaCoin = artifacts.require("MetaCoin");
const ERC20 = artifacts.require("ERC20");
const MyToken = artifacts.require("MyToken");

module.exports = function (deployer) {
  // deployer.deploy(ConvertLib);
  // deployer.link(ConvertLib, MetaCoin);
  deployer.deploy(MyToken, "MyToken", "MTK", 18);
};
