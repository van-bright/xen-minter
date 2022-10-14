// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "hardhat/console.sol";

contract BatcherV2SelfPay {
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1167.md
    bytes32 byteCode;

    address private immutable deployer;
    address private immutable original;

    constructor() {
        deployer = msg.sender;
        original = address(this);
    }

    function createProxies(uint start, uint end) external  {
        require(msg.sender == deployer, "only deployer");

        bytes memory miniProxy = bytes.concat(bytes20(0x3D602d80600A3D3981F3363d3d373d3D3D363d73), bytes20(address(this)), bytes15(0x5af43d82803e903d91602b57fd5bf3));
        byteCode = keccak256(abi.encodePacked(miniProxy));

        address proxy;
        for(uint i = start; i < end; i++) {
            bytes32 salt = keccak256(abi.encodePacked(i));
            assembly {
                proxy := create2(0, add(miniProxy, 32), mload(miniProxy), salt)
            }
        }
    }

    function proxyFor(uint i) public view returns (address proxy) {
        bytes32 salt = keccak256(abi.encodePacked(i));
        proxy = address(uint160(uint(keccak256(abi.encodePacked(
                hex'ff',
                address(this),
                salt,
                byteCode
            )))));
    }

    function executeN(uint start, uint end, address target, address recipient) external {
        require(msg.sender == deployer, "Only deployer can call this function.");

        for(uint i = start; i < end; i++) {
            address proxy = proxyFor(i);
            BatcherV2SelfPay(proxy).callback2(proxy, target, recipient);
        }
    }

    bytes constant claimRank = hex"9ff054df0000000000000000000000000000000000000000000000000000000000000001";
    function callback2(address proxy, address target, address recipient) external {
         require(msg.sender == original, "only original");

        bytes memory usersMint = abi.encodeWithSelector(0xdf282331, proxy);
        (bool success, bytes memory info) = target.staticcall(usersMint);

        (, , uint256 maturityTs, uint256 rank, , )
                = abi.decode(info, (address, uint256, uint256, uint256, uint256, uint256));

        bool claimable = rank > 0 && block.timestamp > maturityTs;
        if (claimable) {
            bytes memory claimMintRewardAndShare = abi.encodeWithSelector(0x1c560305, recipient, 100);
            ( success,) = target.call(claimMintRewardAndShare);
            claimable = success;
        }
        // if (!success)  console.log("claim failed: %s", string(reason));
        if (rank == 0 || claimable) {
            (success,) = target.call(claimRank);
        }
    }
}