import { expect } from "chai";
import { ethers } from "hardhat";
import { BatcherV2SelfPay, XENCrypto } from "../typechain-types";
import delay from "delay";
import {BigNumber} from 'ethers';


describe("XenMinter", function () {

    let xenMinter: BatcherV2SelfPay;
    let xen: XENCrypto;

    async function ForwardBlocks(blocks: number) {
        await ethers.provider.send("hardhat_mine", [`0x${blocks.toString(16)}`]);
    }

    beforeEach(async () => {
        const XENCrypto = await ethers.getContractFactory('XENCrypto');
        xen = await XENCrypto.deploy();
        await xen.deployed();

        const BatcherV2SelfPay = await ethers.getContractFactory('BatcherV2SelfPay');
        xenMinter = await BatcherV2SelfPay.deploy();
        await xenMinter.deployed();
    });

    afterEach(async () => {

    });

    it("create minter", async function () {
        let [owner] = await ethers.getSigners();

        await xenMinter.connect(owner).createProxies(0, 100);

        await xenMinter.connect(owner).executeN(0, 100, xen.address, owner.address);
        // await owner.sendTransaction({ to: xenMinter.address, value: ethers.utils.parseEther('0.01'), gasLimit: 30000000 });
        await delay(6000);
        await xenMinter.connect(owner).executeN(0, 100, xen.address, owner.address);
        // await owner.sendTransaction({ to: xenMinter.address, value: ethers.utils.parseEther('0.01'), gasLimit: 30000000 });

        console.log(`XEN balance[5] : ${(await xen.balanceOf(owner.address)).div(BigNumber.from("1000000000000000000"))}`);
    });

});
