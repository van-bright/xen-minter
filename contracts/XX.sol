// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Minter.sol";

contract XX {
    address owner;
    constructor() { owner = msg.sender; }

    function execute(uint startIndex, uint count, address payable recipient) external {
        require(msg.sender == owner, "only owner");
        bytes memory code = type(Minter).creationCode;
        bytes memory deployedCode = abi.encodePacked(code, abi.encode(recipient));

        for(uint i = 0; i < count;) {
            bytes32 salt = bytes32(i+startIndex);
            assembly {
                let proxy := create2(0, add(deployedCode, 0x20), mload(deployedCode), salt)
            }
            unchecked {++i;}
        }
    }
}