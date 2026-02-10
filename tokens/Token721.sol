// SPDX-License-Identifier: MIT
pragma solidity ^0.8.30;

import "@openzeppelin/contracts@5.0.0/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts@5.0.0/token/ERC721/extensions/ERC721URIStorage.sol";
import "@openzeppelin/contracts@5.0.0/token/ERC721/extensions/ERC721Burnable.sol";
import "@openzeppelin/contracts@5.0.0/access/Ownable.sol";

contract Token721 is ERC721, ERC721Burnable, ERC721URIStorage, Ownable {
    
    constructor(address _initialOwner)ERC721("Token721", "T7K") Ownable(_initialOwner){
    }

    function safeMint(address _to, uint256 _tokenId, string memory _uri) public onlyOwner {
        _safeMint(_to, _tokenId);
        _setTokenURI(_tokenId, _uri);
    }

    // The following functions are overrides required by Solidity.
    function supportsInterface(bytes4 _interfaceId) public view override (ERC721, ERC721URIStorage) returns (bool) {
         return super.supportsInterface(_interfaceId);
    }

    function tokenURI(uint256 _tokenId) public view override(ERC721, ERC721URIStorage) returns (string memory) {
        return super.tokenURI(_tokenId);
    }
    
}