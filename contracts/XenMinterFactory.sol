// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Minter.sol";

import "hardhat/console.sol";

contract XenMinterFactory {

    // term => Minter[]
    mapping(uint256 => Minter[]) public minters;

    address owner;
    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    receive() external payable {}

    address public immutable XEN_CONTRACT; // = 0x06450dEe7FD2Fb8E39061434BAbCFC05599a6Fb8;

    constructor(address xen) {
        owner = msg.sender;
        XEN_CONTRACT = xen;
    }

    function withdraw(address payable recipient) public onlyOwner {
        recipient.transfer(address(this).balance);
    }

    function createMinters(uint256 term) public payable onlyOwner {
        Minter minter = new Minter(XEN_CONTRACT);
        // 转手续费
        payable(minter).transfer(0.006 ether);
        // claimRank
        minter.claimRank(term);
        // 记录minter
        minters[term].push(minter);
    }

    function createManyMinters(uint256 term, uint256 counts) public payable onlyOwner {
        for (uint i = 0; i < counts; i++) {
            createMinters(term);
        }
    }

    function batchCreateMinters(uint256[] memory terms, uint256[] memory counts) public payable onlyOwner {
        require(terms.length == counts.length, "length mismatch");

        for (uint i = 0; i < terms.length; i++) {
            createManyMinters(terms[i], counts[i]);
        }
    }

    function claimRewards(uint256[] memory terms, address recipient) public payable onlyOwner {
        for (uint i = 0; i < terms.length; i++) {
            Minter[] memory minterArray = minters[terms[i]];

            for (uint j = 0; j < minterArray.length; j++) {
                minterArray[j].claimReward(recipient);
            }
        }
    }
}