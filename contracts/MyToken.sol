// SPDX-License-Identifier: MIT
pragma solidity ^0.8.13;

import "./ERC20.sol";

contract MyToken is ERC20 {
     uint256 public initialAmount;
    constructor(string memory name, string memory symbol, uint8 decimals)
        ERC20(name, symbol, decimals)
    {
        initialAmount = 666;
        _mint(msg.sender, initialAmount * 10 ** uint256(decimals));
    }
}
