// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Minter {

    address public XEN_CONTRACT;
    address public owner;

    modifier onlyOwner() {
        require(msg.sender == owner, "only owner");
        _;
    }

    constructor(address xen) {
        owner = msg.sender;
        XEN_CONTRACT = xen;
    }

    receive() external payable {}

    function claimRank(uint256 rank) public onlyOwner {
        (bool result, bytes memory data) = XEN_CONTRACT.call(
            abi.encodeWithSignature("claimRank(uint256)", rank)
        );

        require(result, string(data));
    }

    function claimReward(address to) public onlyOwner {
        (bool result, bytes memory data) = XEN_CONTRACT.call(
            abi.encodeWithSignature("claimMintRewardAndShare(address,uint256)", to, 100)
        );

        require(result, string(data));
    }
}