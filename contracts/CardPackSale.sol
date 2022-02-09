pragma solidity ^0.8.0;

// SPDX-License-Identifier: Unlicensed

import "./CardPack.sol";
import "./GameCoin.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CardPackSale is Ownable {
    GameCoin gameCoin;
    CardPack cardPack;

    constructor() Ownable() {
    }

    function buyCardPack(uint256 packType) public {
        uint256 price = cardPack.getPackPrice(packType);
        require(price > 0, "invalid packType");
        gameCoin.transferFrom(msg.sender, owner(), cardPack.getPackPrice(packType));
        cardPack.createCardPack(msg.sender, packType);
    }

    function setCardPack(address cardPackAddress_) public onlyOwner {
        cardPack = CardPack(cardPackAddress_);
    }

    function setGameCoin(address gameCoinAddress_) public onlyOwner {
        gameCoin = GameCoin(gameCoinAddress_);
    }
}