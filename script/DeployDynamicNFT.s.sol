//SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

import {Script,console} from "forge-std/Script.sol";
import {DynamicNFT} from "../src/DynamicNFT.sol";
import {Base64} from "@openzeppelin/contracts/utils/Base64.sol";


contract DeployDynamicNFT is Script {
    DynamicNFT private s_dynamicNFT;

   

    function run() external returns (DynamicNFT) {

 string memory happySVGImageURI = vm.readFile("./imgs/happy.svg");
    string memory sadSVGImageURI = vm.readFile("./imgs/sad.svg");        
        vm.startBroadcast();
        s_dynamicNFT = new DynamicNFT(
            svgToImageURI(happySVGImageURI),
            svgToImageURI(sadSVGImageURI)
            );
            console.log("happySVGImageURI: ", svgToImageURI(happySVGImageURI));

        vm.stopBroadcast();
        return s_dynamicNFT;
    }

    function svgToImageURI(string memory svg) public pure returns (string memory) {
        string memory prefix = "data:image/svg+xml;base64,";
        string memory base64Encoded = Base64.encode(bytes(string(abi.encodePacked(svg))));
        return string(abi.encodePacked(prefix, base64Encoded));
    }
}
