

import { ethers } from "hardhat";
import { Addresses } from "./address";

async function main() {
  // const v2 = await ethers.getContractAt('BatcherV2', BatcherV2Addr);

  // await v2.executeN(100, {gasLimit: 20000000});
  let [owner] = await ethers.getSigners();
  await owner.sendTransaction({ to: Addresses.BatcherV2, value: ethers.utils.parseEther('0.01'), gasLimit: 500000 });

  const XEN = await ethers.getContractAt('XENCrypto', Addresses.XEN);

  console.log(`balanceOf: ${await XEN.balanceOf('0x9f8fc873d5191e34d7eb7b8f91f53824976c0fea')}`);

  console.log(`eth balance: ${await ethers.provider.getBalance(Addresses.BatcherV2)}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
