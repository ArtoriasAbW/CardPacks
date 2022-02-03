pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract CardPack is ERC1155, AccessControl {

    bytes32 public constant CARD_PACK_MANIPULATOR = keccak256("CARD_PACK_MANIPULATOR");
    bytes32 public constant ADMIN = keccak256("ADMIN");

    enum CardPackType {
        COMMON,
        EPIC,
        LEGENDAY
    }
    
    constructor() ERC1155("cardpacks") {
        _setupRole(ADMIN, msg.sender);
        _setRoleAdmin(CARD_PACK_MANIPULATOR, ADMIN);
    }

    function createCardPack(address to, CardPackType packType) public onlyRole(CARD_PACK_MANIPULATOR) {
        _mint(to, uint256(packType), 1, "");
    }

    function removeCardPack(address from, CardPackType packType) public onlyRole(CARD_PACK_MANIPULATOR) {
        _burn(from, uint256(packType), 1);
    }

    function addManipulator(address account) public onlyRole(ADMIN) {
        grantRole(CARD_PACK_MANIPULATOR, account);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, AccessControl) returns (bool) {
        return ERC1155.supportsInterface(interfaceId) || AccessControl.supportsInterface(interfaceId);
    }
    
}