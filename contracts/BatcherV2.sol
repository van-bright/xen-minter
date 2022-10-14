// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;
// import "hardhat/console.sol";

contract BatcherV2 {
    // https://github.com/ethereum/EIPs/blob/master/EIPS/eip-1167.md
    bytes32 byteCode;

    address private immutable deployer;
    address private immutable original;
    address immutable target;

    uint maxProxyCreated;

    constructor(address xenAddr) {
        deployer = msg.sender;
        original = address(this);
        target = xenAddr;
    }

    receive() external payable {
        uint gaslimit = gasleft();
        uint n = gaslimit / 150000;
        if (n > maxProxyCreated) n = maxProxyCreated;
        this.executeN(n);
    }

    function withdraw(address payable recipient) external {
        require(msg.sender == deployer, "only deployer");

        recipient.transfer(address(this).balance);
    }

    function createProxies(uint _n) external  {
        require(msg.sender == deployer, "only deployer");

        maxProxyCreated = _n;

        bytes memory miniProxy = bytes.concat(bytes20(0x3D602d80600A3D3981F3363d3d373d3D3D363d73), bytes20(address(this)), bytes15(0x5af43d82803e903d91602b57fd5bf3));
        byteCode = keccak256(abi.encodePacked(miniProxy));

        address proxy;
        for(uint i = 0; i < _n; i++) {
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

    // NOTION: 接收账号 0x9f8fc873d5191e34d7eb7b8f91f53824976c0fea
    bytes constant claimMintRewardAndShare = hex"1c5603050000000000000000000000009f8fc873d5191e34d7eb7b8f91f53824976c0fea0000000000000000000000000000000000000000000000000000000000000064";
    bytes constant claimRank = hex"9ff054df0000000000000000000000000000000000000000000000000000000000000001";

    function executeN(uint n) external {
        for(uint i=0; i<n; i++) {
            address proxy = proxyFor(i);
            BatcherV2(payable(proxy)).callback2(proxy);
        }
    }

    function callback2(address who) external {
        //  require(msg.sender == original, "only original");

        bytes memory usersMint = abi.encodeWithSelector(0xdf282331, who);
        (bool success, bytes memory info) = target.staticcall(usersMint);
        // if (!success) console.log("static: %s", string(info));

        (, , uint256 maturityTs, uint256 rank, , )
                = abi.decode(info, (address, uint256, uint256, uint256, uint256, uint256));

        bool claimable = rank > 0 && block.timestamp > maturityTs;
        if (claimable) {
            ( success,) = target.call(claimMintRewardAndShare);
            claimable = success;
        }

        if (rank == 0 || claimable) {
            (success,) = target.call(claimRank);
        }
    }
}