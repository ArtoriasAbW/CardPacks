pragma solidity ^0.8.0;

// SPDX-License-Identifier: Unlicensed

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GameCoin is ERC20 {

    constructor() ERC20("GameCoin", "GC") {
        _mint(msg.sender, 1_000_000_000);
    }
}