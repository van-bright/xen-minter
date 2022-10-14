

import { ethers } from "hardhat";

async function main() {
 // Deployed Contracts"
  const XENAddr = '0x8F80400c97D23F53227042bB30b42b625A4bA685';
  const BatcherV2Addr = '0x9E325dF66B29277a100848b1c9cfc51c993C5617';

  const v2 = await ethers.getContractAt('BatcherV2', BatcherV2Addr);

  await v2.executeN(100, {gasLimit: 20000000});

  const XEN = await ethers.getContractAt('XENCrypto', XENAddr);

  console.log(`balanceOf: ${await XEN.balanceOf('0x9f8fc873d5191e34d7eb7b8f91f53824976c0fea')}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
