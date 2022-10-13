import { time, loadFixture } from "@nomicfoundation/hardhat-network-helpers";
import { anyValue } from "@nomicfoundation/hardhat-chai-matchers/withArgs";
import { expect } from "chai";
import { ethers } from "hardhat";
import { XENCrypto, XenMinterFactory } from "../typechain-types";
import delay from "delay";
import {BigNumber} from 'ethers';

describe("XenMinter", function () {

    let xenMinter: XenMinterFactory;
    let xen: XENCrypto;

    async function ForwardBlocks(blocks: number) {
        await ethers.provider.send("hardhat_mine", [`0x${blocks.toString(16)}`]);
    }

    beforeEach(async () => {
        const XENCrypto = await ethers.getContractFactory('XENCrypto');
        xen = await XENCrypto.deploy();
        await xen.deployed();

        const XenMinterFactory = await ethers.getContractFactory('XenMinterFactory');
        xenMinter = await XenMinterFactory.deploy(xen.address);
        await xenMinter.deployed();
    });

    afterEach(async () => {

    });

    it("create minter", async function () {
        let [owner] = await ethers.getSigners();

        await xenMinter.connect(owner).createMinters(50, owner.address);

        await delay(6000);

        await xenMinter.connect(owner).createMinters(50, owner.address);

        console.log(`XEN balance[5] : ${(await xen.balanceOf(owner.address)).div(BigNumber.from("1000000000000000000"))}`);
    });

    // it("create batch minters", async function () {
    //     let [owner] = await ethers.getSigners();

    //     let terms =  [5, 10, 15, 20, 25, 30];
    //     // let counts = [10, 10, 10, 10, 10, 10];
    //     let counts = [6, 6, 6, 6, 6, 6];

    //     await xenMinter.batchCreateMinters(terms, counts);

    //     await delay(6000);

    //     await xenMinter.claimRewards([5], owner.address);

    //     console.log(`XEN balance[5] : ${await xen.balanceOf(owner.address)}`);

    //     await delay(6000);
    //     await xenMinter.claimRewards([10], owner.address);
    //     console.log(`XEN balance[5, 10] : ${await xen.balanceOf(owner.address)}`);

    // });

});
