const MyToken = artifacts.require("MyToken");

contract("MyToken", (accounts) => {
  it("total amount should be 666", async () => {
    const myToken = await MyToken.deployed();
    const decimalsFromContract = await myToken.decimals();
    // await myToken.mint(accounts[0], 100);
    const balance = await myToken.balanceOf(accounts[0]);
    const decimals = decimalsFromContract.toNumber();
    const expectedBalance = "666" + "0".repeat(decimals); // "666" followed by 18 zeros

    assert.equal(
      balance.toString(),
      expectedBalance,
      "Balance should be equal to 666"
    );
  });
});

// import  { accounts, contract } from'@openzeppelin/test-environment';
// import { describe } from 'node:test';x
// const MyToken = contract.fromArtifact("MyToken");

// describe("MyToken", () => {
//     it("should be able to mint", async () => {
//         const myToken = await MyToken.deployed();
//         await myToken.mint(accounts[0], 100);
//         const balance = await myToken.balanceOf(accounts[0]);
//         console.log(balance.toNumber());
//         // assert.equal(balance.toNumber(), 100);
//     });
// })
