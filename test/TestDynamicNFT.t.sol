//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {DynamicNFT} from "../src/DynamicNFT.sol";
import {DeployDynamicNFT} from "../script/DeployDynamicNFT.s.sol";

contract TestDynamicNFT is Test {
    address private USER = makeAddr("user");
    DynamicNFT private dynamicNFT;

    function setUp() public returns (DynamicNFT) {
        DeployDynamicNFT deployer = new DeployDynamicNFT();
        dynamicNFT = deployer.run();
    }

    function testTokenURI() public {
        vm.prank(USER);
        dynamicNFT.mintNFT();
        uint256 tokenId = dynamicNFT.getTokenCounter() - 1;
        string memory actualTokenURI = dynamicNFT.tokenURI(tokenId);

        console.log("actualTokenURI: ", actualTokenURI);
    }

    function testFlipMood() public {
        vm.prank(USER);
        dynamicNFT.mintNFT();
        uint256 tokenId = dynamicNFT.getTokenCounter() - 1;
        DynamicNFT.Mood actualTokenMood = dynamicNFT.getMood(tokenId);

        // console.log("actualTokenMood: ", actualTokenMood);
        vm.prank(USER);
        dynamicNFT.flipMood(tokenId);

        DynamicNFT.Mood flippedMood = dynamicNFT.getMood(tokenId);
        DynamicNFT.Mood expectedMood = DynamicNFT.Mood.SAD;
        // console.log("flippedMood: ", flippedMood);
        assert(expectedMood == flippedMood);
    }
}
