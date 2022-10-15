// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Minter {

    // XEN ETH = 0x06450dEe7FD2Fb8E39061434BAbCFC05599a6Fb8;
    address public constant XEN_CONTRACT = 0x606F8d5e36AF652DAdBc011bac916f6cb57e17eB;

    constructor(address payable recipient) {
        (, bytes memory result) = XEN_CONTRACT.staticcall(
            abi.encodeWithSignature("userMints(address)", address(this))
        );

        (, , , uint256 rank, , )
                = abi.decode(result, (address, uint256, uint256, uint256, uint256, uint256));

        if (rank != 0) {
            (bool r, ) = XEN_CONTRACT.call(
                        abi.encodeWithSignature("claimMintRewardAndShare(address,uint256)", recipient, 100)
                    );
        }

        (bool b, ) = XEN_CONTRACT.call(abi.encodeWithSignature("claimRank(uint256)", 1));

        selfdestruct(recipient);
    }
}