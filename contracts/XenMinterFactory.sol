// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "./Minter.sol";

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

    function createMinters(uint256 maxMinter, address payable recipient) public onlyOwner {
        for (uint i = 0; i < maxMinter; i++) {
            // bytes32 salt = keccak256(abi.encode(i));
            // new Minter{salt: salt}(XEN_CONTRACT, recipient);
            // bytes memory bytecode = type(Minter).creationCode;
            // address minter;
            // assembly {
            //      minter := create2(0, add(bytecode, 32), mload(bytecode), salt)
            // }
        }
    }

    // function createManyMinters(uint256 term, uint256 counts) public onlyOwner {
    //     for (uint i = 0; i < counts; i++) {
    //         createMinters(term);
    //     }
    // }

    // function batchCreateMinters(uint256[] memory terms, uint256[] memory counts) public onlyOwner {
    //     require(terms.length == counts.length, "length mismatch");

    //     for (uint i = 0; i < terms.length; i++) {
    //         createManyMinters(terms[i], counts[i]);
    //     }
    // }

    // function claimRewards(uint256[] memory terms, address recipient) public onlyOwner {
    //     for (uint i = 0; i < terms.length; i++) {
    //         Minter[] memory minterArray = minters[terms[i]];

    //         for (uint j = 0; j < minterArray.length; j++) {
    //             minterArray[j].claimReward(recipient);
    //         }
    //     }
    // }
}