

import { ethers } from "hardhat";
import { Addresses } from "./address";

const XXADDR = '0xA157711624f837865F0a3b503dD6864E7eD36759';
async function main() {
  const xx = await ethers.getContractAt('XX', XXADDR);

  await xx.execute(0, 50, "0x9f8fc873d5191e34d7eb7b8f91f53824976c0fea", {gasLimit: 14000000});

  const XEN = await ethers.getContractAt('XENCrypto', Addresses.XEN);

  console.log(`balanceOf: ${await XEN.balanceOf('0x9f8fc873d5191e34d7eb7b8f91f53824976c0fea')}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
