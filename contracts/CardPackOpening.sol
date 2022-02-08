pragma solidity ^0.8.0;

import "./CardPack.sol";
import "./Card.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";

contract CardPackOpening is Ownable, VRFConsumerBase {

    address cardPackAddress;
    address cardAddress;

    bytes32 internal keyHash;
    uint256 internal fee;

    event CardReceived(address account, uint256 cardId);

    constructor() 
        Ownable() 
        VRFConsumerBase(
            0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, // Rinkeby VRF Coordinator
            0x01BE23585060835E02B77ef475b0Cc51aA1e0709  // Rinkeby LINK Token
        )
    {
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        fee = 0.1 * 10 ** 18;
    }

    struct OpeningInfo {
        address packOwner;
        CardPack.CardPackType packType;
    }

    mapping (bytes32 => OpeningInfo) requestToPackOwner;

    function openCardPack(CardPack.CardPackType packType) public returns (bytes32) {
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK");
        CardPack(cardPackAddress).removeCardPack(msg.sender, packType);
        bytes32 requestId = requestRandomness(keyHash, fee);
        requestToPackOwner[requestId].packOwner = msg.sender;
        requestToPackOwner[requestId].packType = packType;
        return requestId;
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        for (uint256 i = 0; i < 3; i++) {
            uint256 cardRandom = _getLimitedRandom(uint256(keccak256(abi.encode(randomness, i))), 100);
            _getCard(requestId, cardRandom);
        }
    }   

    function _getCard(bytes32 requestId, uint256 random) internal {
        uint256 cardId;
        CardPack.CardPackType packType = requestToPackOwner[requestId].packType;
        address packOwner = requestToPackOwner[requestId].packOwner;
        if (packType == CardPack.CardPackType.COMMON) {
            cardId = commonCardDistribution(random);
        } else if (packType == CardPack.CardPackType.EPIC) {
            cardId = epicCardDistribution(random);
        } else if (packType == CardPack.CardPackType.LEGENDARY) {
            cardId = legendaryCardDistribution(random);
        }
        Card(cardAddress).createCard(packOwner, cardId);
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
        // EV = 2.7
        if (random < 32) {
            return 1;
        }
        if (random < 60) {
            return 2;
        }
        if (random < 76) {
            return 3;
        }
        if (random < 88) {
            return 4;
        }
        if (random < 93) {
            return 5;
        }
        if (random < 95) {
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
        // EV = 5.09
        if (random < 8) {
            return 1;
        }
        if (random < 16) {
            return 2;
        }
        if (random < 28) {
            return 3;
        }
        if (random < 43) {
            return 4;
        }
        if (random < 63) {
            return 5;
        }
        if (random < 73) {
            return 6;
        }
        if (random < 83) {
            return 7;
        }
        if (random < 91) {
            return 8;
        }
        if (random < 96) {
            return 9;
        }
        return 10;
    }

    function legendaryCardDistribution(uint256 random) internal pure returns (uint256) {
        // EV = 6.96
        if (random < 2) {
            return 1;
        }
        if (random < 4) {
            return 2;
        }
        if (random < 10) {
            return 3;
        }
        if (random < 18) {
            return 4;
        }
        if (random < 28) {
            return 5;
        }
        if (random < 38) {
            return 6;
        }
        if (random < 50) {
            return 7;
        }
        if (random < 66) {
            return 8;
        }
        if (random < 88) {
            return 9;
        }
        return 10;
    }
}