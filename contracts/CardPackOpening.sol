pragma solidity ^0.8.0;

// SPDX-License-Identifier: Unlicensed

import "./CardPack.sol";
import "./Card.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBase.sol";
import "@uniswap/v2-periphery/contracts/interfaces/IUniswapV2Router02.sol";

contract CardPackOpening is Ownable, VRFConsumerBase {

    address cardPackAddress;
    address cardAddress;

    CardPack cardPack;
    Card card;

    bytes32 internal keyHash;
    uint256 internal fee;

    struct OpeningInfo {
        address packOwner;
        uint256 packType;
    }

    mapping (bytes32 => OpeningInfo) requestToPackOwner;

    event CardReceived(address account, uint256 cardId);

    // swapInfo [rinkeby]
    address routerAddress = 0x7a250d5630B4cF539739dF2C5dAcb4c659F2488D;
    address WETHaddr = 0xc778417E063141139Fce010982780140Aa0cD5Ab;
    address LINKaddr = 0x01BE23585060835E02B77ef475b0Cc51aA1e0709;
    IUniswapV2Router02 router;

    constructor() 
        Ownable() 
        VRFConsumerBase(
            0xb3dCcb4Cf7a26f6cf6B120Cf5A73875B7BBc655B, // Rinkeby VRF Coordinator
            0x01BE23585060835E02B77ef475b0Cc51aA1e0709  // Rinkeby LINK Token
        )
    {
        keyHash = 0x2ed0feb3e7fd2022120aa84fab1945545a9f2ffc9076fd6156fa96eaff4c1311;
        fee = 0.1 * 10 ** 18;
        router = IUniswapV2Router02(routerAddress);
    }

    fallback() external payable {
        
    }

    function openCardPack(uint256 packType) public payable returns (bytes32) {
        require(cardPack.balanceOf(msg.sender, uint256(packType)) > 0, "sender doesn't have pack of this type");
        address[] memory path = new address[](2);
        path[0] = WETHaddr;
        path[1] = LINKaddr;
        router.swapETHForExactTokens{value: msg.value}(fee, path, address(this), block.timestamp + 30 minutes);
        (bool sent, ) = payable(msg.sender).call{value: address(this).balance}("");
        require(sent, "Failed to send Ether");
        require(LINK.balanceOf(address(this)) >= fee, "Not enough LINK");
        cardPack.removeCardPack(msg.sender, packType);
        bytes32 requestId = requestRandomness(keyHash, fee);
        requestToPackOwner[requestId].packOwner = msg.sender;
        requestToPackOwner[requestId].packType = packType;
        return requestId;
    }

    function getOpeningPrice() public view returns(uint256[] memory) {
        address[] memory path = new address[](2);
        path[0] = WETHaddr;
        path[1] = LINKaddr;
        return router.getAmountsIn(fee, path);
    }

    function fulfillRandomness(bytes32 requestId, uint256 randomness) internal override {
        for (uint256 i = 0; i < 3; i++) {
            uint256 cardRandom = _getLimitedRandom(uint256(keccak256(abi.encode(randomness, i))), 100);
            _getCard(requestId, cardRandom);
        }
    }   

    function _getCard(bytes32 requestId, uint256 random) internal {
        uint256 packType = requestToPackOwner[requestId].packType;
        address packOwner = requestToPackOwner[requestId].packOwner;
        uint256 cardId = cardPack.getCardByDistribution(packType, random);
        Card(cardAddress).createCard(packOwner, cardId);
    }

    function _getLimitedRandom(uint256 random, uint256 limit) internal pure returns (uint256) {
        return (random % limit) + 1;
    }

    function setCardPack(address cardPackAddress_) public onlyOwner {
        cardPack = CardPack(cardPackAddress_);
    }

    function setCard(address cardAddress_) public onlyOwner {
        card = Card(cardAddress_);
    }
}