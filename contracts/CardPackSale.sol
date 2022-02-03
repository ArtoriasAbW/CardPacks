pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC20/IERC20.sol";
import "./CardPack.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CardPackSale is Ownable {

    address cardPackAddress;
    IERC20 gameCoin;

    mapping (CardPack.CardPackType => uint256) prices;

    constructor() Ownable() {
        _setPrices();
    }

    function buyCardPack(CardPack.CardPackType packType) public {
        uint256 price = prices[packType];
        require(price > 0, "invalid packType");
        gameCoin.transferFrom(msg.sender, address(this), price);
        CardPack(cardPackAddress).createCardPack(msg.sender, packType);
    }

    function setCardPack(address cardPackAddress_) public onlyOwner {
        cardPackAddress = cardPackAddress_;
    }

    function _setPrices() internal {
        prices[CardPack.CardPackType.COMMON] = 10;
        prices[CardPack.CardPackType.EPIC] = 100;
        prices[CardPack.CardPackType.LEGENDARY] = 500;
    }

}