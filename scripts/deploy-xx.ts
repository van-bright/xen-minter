import delay from "delay";
import { ethers } from "hardhat";
import { Addresses } from "./address";

async function main() {
  const XENCrypto = await ethers.getContractFactory("XX");
  const xen = await XENCrypto.deploy();
  await xen.deployed();
  console.log(`XX deployed: ${xen.address}`);

//   await xen.execute(0, 50, "0x9f8fc873d5191e34d7eb7b8f91f53824976c0fea", {gasLimit: 14000000});
//   const XEN = await ethers.getContractAt('XENCrypto', Addresses.XEN);




//   await XEN.claimRank(2);
//   await delay(4000);
//   await XEN.claimMintRewardAndShare("0x9f8fc873d5191e34d7eb7b8f91f53824976c0fea", 100);
//   console.log(`balanceOf: ${await XEN.balanceOf('0x9f8fc873d5191e34d7eb7b8f91f53824976c0fea')}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
