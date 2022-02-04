pragma solidity ^0.8.0;

import "./CardPack.sol";
import "./Card.sol";
import "@openzeppelin/contracts/access/Ownable.sol";

contract CardPackOpening is Ownable {

    address cardPackAddress;
    address cardAddress;

    constructor() Ownable() {

    }

    function openCardPack(CardPack.CardPackType packType) public {
        // sent fee, exchange to link, call chainlink, get random
        CardPack(cardPackAddress).removeCardPack(msg.sender, packType);
        uint256 random = uint256(keccak256(abi.encode(blockhash(block.number - 1)))); // bad random
        for (uint256 i = 0; i < 3; i++) {
            uint256 cardRandom = _getLimitedRandom(uint256(keccak256(abi.encode(random, i))), 100);
            _createCard(cardRandom, packType);
        }
    }

    function _createCard(uint256 random, CardPack.CardPackType packType) internal {
        uint256 cardId;
        if (packType == CardPack.CardPackType.COMMON) {
            cardId = commonCardDistribution(random);
        } else if (packType == CardPack.CardPackType.EPIC) {
            cardId = epicCardDistribution(random);
        } else if (packType == CardPack.CardPackType.LEGENDARY) {
            cardId = legendaryCardDistribution(random);
        }
        Card(cardAddress).createCard(cardId);
    }

    function _getLimitedRandom(uint256 random, uint256 limit) internal pure returns (uint256) {
        return (random % limit) + 1;
    }

    function setCardPack(address cardPackAddress_) public onlyOwner {
        cardPackAddress = cardPackAddress_;
    }

    function setCard(address cardAddress_) public onlyOwner {
        cardAddress = cardAddress_;
    }

    function commonCardDistribution(uint256 random) internal pure returns (uint256) {
        // expected value is 2.89
        if (random < 28) {
            return 1;
        }
        if (random < 56) {
            return 2;
        }
        if (random < 74) {
            return 3;
        }
        if (random < 84) {
            return 4;
        }
        if (random < 89) {
            return 5;
        }
        if (random < 93) {
            return 6;
        }
        if (random < 97) {
            return 7;
        }
        if (random < 99) {
            return 8;
        }
        if (random == 99) {
            return 9;
        }
        return 10;
    }

    function epicCardDistribution(uint256 random) internal pure returns (uint256) {
        if (random < 28) {
            return 1;
        }
        if (random < 56) {
            return 2;
        }
        if (random < 74) {
            return 3;
        }
        if (random < 84) {
            return 4;
        }
        if (random < 89) {
            return 5;
        }
        if (random < 93) {
            return 6;
        }
        if (random < 97) {
            return 7;
        }
        if (random < 99) {
            return 8;
        }
        if (random == 99) {
            return 9;
        }
        return 10;
    }

    function legendaryCardDistribution(uint256 random) internal pure returns (uint256) {
        if (random < 28) {
            return 1;
        }
        if (random < 56) {
            return 2;
        }
        if (random < 74) {
            return 3;
        }
        if (random < 84) {
            return 4;
        }
        if (random < 89) {
            return 5;
        }
        if (random < 93) {
            return 6;
        }
        if (random < 97) {
            return 7;
        }
        if (random < 99) {
            return 8;
        }
        if (random == 99) {
            return 9;
        }
        return 10;
    }
}