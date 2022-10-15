// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

import "hardhat/console.sol";

// interface IXenCrypto {
//     function userMints(address) external view returns(MintInfo memory);
// }
contract Minter {
    // struct MintInfo {
    //     address user;
    //     uint256 term;
    //     uint256 maturityTs;
    //     uint256 rank;
    //     uint256 amplifier;
    //     uint256 eaaRate;
    // }
    // address public XEN_CONTRACT = 0x06450dEe7FD2Fb8E39061434BAbCFC05599a6Fb8;
    address public constant XEN_CONTRACT = 0x133d8F4aB5591ebF5a090b1dCc9d2c4Aa878dd2F;

    constructor(address payable recipient) {
        // (, bytes memory result) = XEN_CONTRACT.staticcall(
        //     abi.encodeWithSignature("userMints(address)", address(this))
        // );

        // (, , uint256 maturityTs, uint256 rank, , )
        //         = abi.decode(result, (address, uint256, uint256, uint256, uint256, uint256));

        // bool claimable = rank > 0 && block.timestamp > maturityTs;
        // bool deployable = (rank == 0);

        // if (claimable) {
            XEN_CONTRACT.call(
                        abi.encodeWithSignature("claimMintRewardAndShare(address,uint256)", recipient, 100)
                    );
        //     deployable = true;
        // }

        // if (deployable) {
             XEN_CONTRACT.call(abi.encodeWithSignature("claimRank(uint256)", 1));
        // }

        selfdestruct(payable(recipient));
    }
}