pragma solidity ^0.8.0;

// SPDX-License-Identifier: Unlicensed

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract CardPack is ERC1155, AccessControl {

    bytes32 public constant CARD_PACK_MANIPULATOR = keccak256("CARD_PACK_MANIPULATOR");
    bytes32 public constant ADMIN = keccak256("ADMIN");

    enum CardPackType {
        COMMON,
        EPIC,
        LEGENDARY
    }

    mapping(uint256 => mapping(uint256 => uint256)) distribution;
    mapping(uint256 => uint256) prices; // price == 0 => not for sale
    
    uint256 packTypesNumber;

    constructor() ERC1155("cardpacks") {
        _setupRole(ADMIN, msg.sender);
        _setRoleAdmin(CARD_PACK_MANIPULATOR, ADMIN);
        _initialCardPacks();
    }

    function createCardPack(address to, uint256 packType) public onlyRole(CARD_PACK_MANIPULATOR) {
        _mint(to, uint256(packType), 1, "");
    }

    function removeCardPack(address from, uint256 packType) public onlyRole(CARD_PACK_MANIPULATOR) {
        _burn(from, uint256(packType), 1);
    }


    function addNewCardPack(uint8[10] memory distribution_, uint256 price) public onlyRole(ADMIN) {
        uint256 left = 1;
        require(distribution_[9] == 101, "invalid distribution last element");
        for (uint256 i = 0; i < 10; i++) {
            uint256 right = distribution_[i];
            require(right > left && right <= 101, "invalid distribution");
            for (uint256 j = left; j < right; ++j) {
                distribution[packTypesNumber][j] = i + 1;
            }
            left = right;
        }
        prices[packTypesNumber] = price;
        packTypesNumber++;
    }

    function _initialCardPacks() internal {
        uint8[10] memory distribution_ = [32, 60, 76, 88, 93, 95, 97, 99, 100, 101];
        addNewCardPack(distribution_, 10); // common
        distribution_ = [8, 16, 28, 43, 63, 73, 83, 91, 96, 101];
        addNewCardPack(distribution_, 100); // epic
        distribution_ = [2, 4, 10, 18, 28, 38, 50, 66, 88, 101];
        addNewCardPack(distribution_, 500); // legendary
    }

    function stopSelling(uint256 packType) public onlyRole(ADMIN) {
        prices[packType] = 0;
    }

    function getCardByDistribution(uint256 packType, uint256 random_) public view returns(uint256) {
        return distribution[packType][random_];
    }

    function getPackPrice(uint256 id_) public view returns(uint256) {
        return prices[id_];
    }

    function addManipulator(address account) public onlyRole(ADMIN) {
        grantRole(CARD_PACK_MANIPULATOR, account);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, AccessControl) returns (bool) {
        return ERC1155.supportsInterface(interfaceId) || AccessControl.supportsInterface(interfaceId);
    }
}