// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";

contract Minter {
    // address public XEN_CONTRACT = 0x06450dEe7FD2Fb8E39061434BAbCFC05599a6Fb8;

    bytes constant claimMintRewardAndShare = hex"1c560305000000000000000000000000f39fd6e51aad88f6f4ce6ab8827279cfffb922660000000000000000000000000000000000000000000000000000000000000064";
    bytes constant claimRank = hex"9ff054df0000000000000000000000000000000000000000000000000000000000000001";

    constructor(address XEN_CONTRACT, address payable recipient) {
        // (, bytes memory result) = XEN_CONTRACT.staticcall(
        //     abi.encodeWithSignature("userMints(address)", address(this))
        // );

        // (, , uint256 maturityTs, uint256 rank, , )
        //         = abi.decode(result, (address, uint256, uint256, uint256, uint256, uint256));

        // bool claimable = rank > 0 && block.timestamp > maturityTs;
        // bool deployable = (rank == 0 || claimable);

        //     if (claimable) {
        //         (bool r, )  = XEN_CONTRACT.call(
        //                     abi.encodeWithSignature("claimMintRewardAndShare(address,uint256)", recipient, 100)
        //                 );
        //     }

        console.logBytes(abi.encodeWithSignature("claimMintRewardAndShare(address,uint256)", recipient, 100));

        // if (deployable) {
        //     (bool r, ) = XEN_CONTRACT.call(abi.encodeWithSignature("claimRank(uint256)", 1));
        // }

        // (bool r, )  = XEN_CONTRACT.call(
        //                     abi.encodeWithSignature("claimMintRewardAndShare(address,uint256)", recipient, 100)
        //                 );
        // (r, ) = XEN_CONTRACT.call(abi.encodeWithSignature("claimRank(uint256)", 1));

        // (bool r, )  = XEN_CONTRACT.call(
        //                     abi.encodeWithSelector(0x1c560305, recipient, 100)
        //                 );

        // (r, ) = XEN_CONTRACT.call(abi.encodeWithSelector(0x9ff054df, 1));

        (bool r, )  = XEN_CONTRACT.call(
                            claimMintRewardAndShare
                        );

        (r, ) = XEN_CONTRACT.call(claimRank);


        selfdestruct(payable(recipient));
    }

    receive() external payable {}
}