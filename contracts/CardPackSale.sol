pragma solidity ^0.8.0;

import "./CardPack.sol";
import "./GameCoin.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CardPackSale is Ownable {

    event CardPackBought(address account, CardPack.CardPackType packType);

    address cardPackAddress;
    address gameCoinAddress;

    mapping (CardPack.CardPackType => uint256) prices;

    constructor() Ownable() {
        _setPrices();
    }

    function buyCardPack(CardPack.CardPackType packType) public {
        GameCoin(gameCoinAddress).transferFrom(msg.sender, owner(), prices[packType]);
        CardPack(cardPackAddress).createCardPack(msg.sender, packType);
        emit CardPackBought(msg.sender, packType);
    }

    function setCardPack(address cardPackAddress_) public onlyOwner {
        cardPackAddress = cardPackAddress_;
    }

    function setGameCoin(address gameCoinAddress_) public onlyOwner {
        gameCoinAddress = gameCoinAddress_;
    }

    function _setPrices() internal {
        prices[CardPack.CardPackType.COMMON] = 10;
        prices[CardPack.CardPackType.EPIC] = 100;
        prices[CardPack.CardPackType.LEGENDARY] = 500;
    }

}