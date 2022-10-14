// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Minter.sol";

contract XX {


    address owner;

    constructor() { owner = msg.sender; }

    function execute(uint startIndex, uint count, address payable recipient) external {
        require(msg.sender == owner, "only owner");

        for(uint i = 0; i < count;) {
            new Minter{salt: bytes32(i + startIndex)}(recipient);
            unchecked {++i;}
        }
    }
}