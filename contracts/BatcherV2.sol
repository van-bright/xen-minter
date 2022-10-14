// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
import "hardhat/console.sol";

contract BatcherV2 {
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1167.md
    bytes32 byteCode;

    address private immutable deployer;
    address private immutable original;
    address immutable target;

    constructor(address _target) {
        deployer = msg.sender;
        original = address(this);
        target = _target;
    }

    receive() external payable {
        this.executeN(100);
    }

    function createProxies(uint _n) external  {
        require(msg.sender == deployer, "only deployer");

        bytes memory miniProxy = bytes.concat(bytes20(0x3D602d80600A3D3981F3363d3d373d3D3D363d73), bytes20(address(this)), bytes15(0x5af43d82803e903d91602b57fd5bf3));
        byteCode = keccak256(abi.encodePacked(miniProxy));

        address proxy;
        for(uint i=0; i<_n; i++) {
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

    // NOTION:  需要替换掉这里面的接收账号
    bytes constant claimMintRewardAndShare = hex"1c560305000000000000000000000000f39fd6e51aad88f6f4ce6ab8827279cfffb922660000000000000000000000000000000000000000000000000000000000000064";
    bytes constant claimRank = hex"9ff054df0000000000000000000000000000000000000000000000000000000000000001";

    function executeN(uint n) external {
        // require(msg.sender == deployer, "Only deployer can call this function.");

        // console.log("executeN:  %s", msg.sender);
        for(uint i=0; i<n; i++) {
            address proxy = proxyFor(i);
            BatcherV2(payable(proxy)).callback2();
        }
    }

    function callback2() external {
        //  require(msg.sender == original, "only original");

        (bool success, bytes memory reason) = target.call(claimMintRewardAndShare);
        // if (!success)  console.log("claim failed: %s", string(reason));
        (success, reason) = target.call(claimRank);
        // if (!success)  console.log("rank failed: %s", string(reason));
        // require(success, "Transaction failed.");
    }

    // function execute(uint n, address _target, bytes memory data) external {
    //     require(msg.sender == deployer, "Only deployer can call this function.");
    //     for(uint i=0; i<n; i++) {
    //         address proxy = proxyFor(msg.sender, i);
    //         BatcherV2(proxy).callback(_target, data);
    //     }
    // }

    // function callback(address _target, bytes memory data) external {
    //     require(msg.sender == original, "only original");

    //     (bool success, ) = _target.call(data);
    //     require(success, "Transaction failed.");
    // }


    // function proxyFor(address sender, uint i) public view returns (address proxy) {
    //     bytes32 salt = keccak256(abi.encodePacked(sender, i));
    //     proxy = address(uint160(uint(keccak256(abi.encodePacked(
    //             hex'ff',
    //             address(this),
    //             salt,
    //             byteCode
    //         )))));
    // }

}