import { expect } from "chai";
import { ethers } from "hardhat";
import { BatcherV2, XENCrypto, XenMinterFactory } from "../typechain-types";
import delay from "delay";
import {BigNumber} from 'ethers';


describe("XenMinter", function () {

    let xenMinter: BatcherV2;
    let xen: XENCrypto;

    async function ForwardBlocks(blocks: number) {
        await ethers.provider.send("hardhat_mine", [`0x${blocks.toString(16)}`]);
    }

    beforeEach(async () => {
        const XENCrypto = await ethers.getContractFactory('XENCrypto');
        xen = await XENCrypto.deploy();
        await xen.deployed();

        const BatcherV2 = await ethers.getContractFactory('BatcherV2');
        xenMinter = await BatcherV2.deploy(xen.address);
        await xenMinter.deployed();
    });

    afterEach(async () => {

    });

    it("create minter", async function () {
        let [owner] = await ethers.getSigners();

        const COUNT = 100;
        await xenMinter.connect(owner).createProxies(COUNT);

        // await xenMinter.connect(owner).executeN(COUNT);
        await owner.sendTransaction({ to: xenMinter.address, value: ethers.utils.parseEther('0.01'), gasLimit: 10000000 });
        await delay(6000);
        // await xenMinter.connect(owner).executeN(COUNT);
        await owner.sendTransaction({ to: xenMinter.address, value: ethers.utils.parseEther('0.01'), gasLimit: 10000000 });

        console.log(`XEN balance[5] : ${(await xen.balanceOf("0x9f8fc873d5191e34d7eb7b8f91f53824976c0fea")).div(BigNumber.from("1000000000000000000"))}`);
    });

});
