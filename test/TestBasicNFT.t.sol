//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Test, console} from "forge-std/Test.sol";
import {BasicNFT} from "../src/BasicNFT.sol";
import {DeployBasicNFT} from "../script/DeployBasicNFT.s.sol";

contract TestBasicNFT is Test {
    BasicNFT private basicNFT;
    address private bob = makeAddr("bob");
    string private tokenUri = "ipfs://example.com";

    function setUp() public {
        DeployBasicNFT deployer = new DeployBasicNFT();
        basicNFT = deployer.run();
    }

    function testNameIsCorrect() public {
        string memory actualName = basicNFT.name();
        string memory expectedName = "Doggies";
        console.log("actual name: ", actualName);
        assert(keccak256(abi.encodePacked(actualName)) == keccak256(abi.encodePacked(expectedName)));
    }

    function testMintNFTIncrementsTokenCounter() public {
        uint256 initialTokenCounter = 0;
        string memory tokenUri = "ipfs://example.com";

        vm.prank(bob);
        basicNFT.mintNFT(tokenUri);

        uint256 mintedTokenCounter = basicNFT.getTokenCounter();

        assertEq(mintedTokenCounter, initialTokenCounter + 1);
    }

    function testMintNFTAddsTokenURI() public {
        vm.prank(bob);
        basicNFT.mintNFT(tokenUri);

        uint256 mintedTokenCounter = basicNFT.getTokenCounter();
        string memory actualTokenUri = basicNFT.tokenURI(mintedTokenCounter - 1);

        assertEq(actualTokenUri, tokenUri);
    }

    function testMintIncreaseTokenBalanceOfMsgSender() public {
        vm.prank(bob);
        basicNFT.mintNFT(tokenUri);

        uint256 mintedTokenCounter = basicNFT.getTokenCounter();
        uint256 actualBalance = basicNFT.balanceOf(bob);

        assertEq(actualBalance, 1);
        assertEq(mintedTokenCounter, 1);
    }

    function testAddressThatMintsIsTheOwnerOfThatToken() public {
        //arrange
        vm.prank(bob);
        basicNFT.mintNFT(tokenUri);
        uint256 mintedTokenId = basicNFT.getTokenCounter() - 1;

        assert(basicNFT.ownerOf(mintedTokenId) == address(bob));
    }
}
