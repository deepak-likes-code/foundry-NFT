//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {ERC721} from "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";

contract DynamicNFT is ERC721 {
    error DynamicNFT__NonExistentTokenId(uint256 tokenId);
    error DynamicNFT__NotTokenOwner();

    string private s_happySVGImageURI;
    string private s_sadSVGImageURI;
    uint256 private s_tokenCounter;

    enum Mood {
        HAPPY,
        SAD
    }

    mapping(uint256 => Mood) private s_tokenIdToMood;

    constructor(string memory happySVGImageURI, string memory sadSVGImageURI) ERC721("MoodNFT", "MOOD") {
        s_tokenCounter = 0;
        s_happySVGImageURI = happySVGImageURI;
        s_sadSVGImageURI = sadSVGImageURI;
    }

    function mintNFT() public {
        _safeMint(msg.sender, s_tokenCounter);
        s_tokenIdToMood[s_tokenCounter] = Mood.HAPPY;
        s_tokenCounter = s_tokenCounter + 1;
    }

    function _baseURI() internal view override returns (string memory) {
        return "data:application/json;base64,";
    }

    function tokenURI(uint256 tokenId) public view override returns (string memory) {
        if (tokenId > s_tokenCounter) {
            revert DynamicNFT__NonExistentTokenId(tokenId);
        }
        string memory imageURI;

        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            imageURI = s_happySVGImageURI;
        } else {
            imageURI = s_sadSVGImageURI;
        }

        return string(
            abi.encodePacked(
                _baseURI(),
                Base64.encode(
                    bytes( // bytes casting actually unnecessary as 'abi.encodePacked()' returns a bytes
                        abi.encodePacked(
                            '{"name":"',
                            name(),
                            '", "description":"An NFT that reflects the mood of the owner, 100% on Chain!", ',
                            '"attributes": [{"trait_type": "moodiness", "value": 100}], "image":"',
                            imageURI,
                            '"}'
                        )
                    )
                )
            )
        );
    }

    function flipMood(uint256 tokenId) public {
        if (_isAuthorized(msg.sender, msg.sender, tokenId) == false) {
            revert DynamicNFT__NotTokenOwner();
        }
        if (s_tokenIdToMood[tokenId] == Mood.HAPPY) {
            s_tokenIdToMood[tokenId] = Mood.SAD;
        } else {
            s_tokenIdToMood[tokenId] = Mood.HAPPY;
        }
    }

    // Getters

    function getTokenCounter() external view returns (uint256) {
        return s_tokenCounter;
    }

    function getMood(uint256 tokenId) external view returns (Mood) {
        return s_tokenIdToMood[tokenId];
    }
}
