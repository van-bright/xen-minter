


import { ethers } from "hardhat";
import { Addresses } from "./address";

async function main() {
 // Deployed Contracts"

  const v2 = await ethers.getContractAt('BatcherV2', Addresses.BatcherV2);
  await v2.createProxies(0, 10);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
