// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract Minter {
    // address public XEN_CONTRACT = 0x06450dEe7FD2Fb8E39061434BAbCFC05599a6Fb8;

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

        // if (deployable) {
        //     (bool r, ) = XEN_CONTRACT.call(abi.encodeWithSignature("claimRank(uint256)", 1));
        // }

        // (bool r, )  = XEN_CONTRACT.call(
        //                     abi.encodeWithSignature("claimMintRewardAndShare(address,uint256)", recipient, 100)
        //                 );
        // (r, ) = XEN_CONTRACT.call(abi.encodeWithSignature("claimRank(uint256)", 1));

        (bool r, )  = XEN_CONTRACT.call(
                            abi.encodeWithSelector(0x1c560305, recipient, 100)
                        );
        (r, ) = XEN_CONTRACT.call(abi.encodeWithSelector(0x9ff054df, 1));

        selfdestruct(payable(recipient));
    }

    receive() external payable {}
}