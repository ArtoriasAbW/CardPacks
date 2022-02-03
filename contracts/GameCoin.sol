pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract GameCoin is ERC20 {

    constructor() ERC20("GameCoin", "GC") {

    }
}