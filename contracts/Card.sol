pragma solidity ^0.8.0;

import "@openzeppelin/contracts/token/ERC1155/ERC1155.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract Card is ERC1155, AccessControl {

    bytes32 public constant CARD_MINTER = keccak256("CARD_MINTER");
    bytes32 public constant ADMIN = keccak256("ADMIN");

    constructor() ERC1155("cards") {
        _setupRole(ADMIN, msg.sender);
        _setRoleAdmin(CARD_MINTER, ADMIN);
    }

    function createCard(address account, uint256 cardId) public onlyRole(CARD_MINTER) {
        _mint(account, cardId, 1, "");
    }

    function addManipulator(address account) public onlyRole(ADMIN) {
        grantRole(CARD_MINTER, account);
    }

    function supportsInterface(bytes4 interfaceId) public view virtual override(ERC1155, AccessControl) returns (bool) {
        return ERC1155.supportsInterface(interfaceId) || AccessControl.supportsInterface(interfaceId);
    }

}

// UniswapV2
//  function swapTokensForExactETH(uint amountOut, uint amountInMax, address[] calldata path, address to, uint deadline)
//  external
//  returns (uint[] memory amounts); 
