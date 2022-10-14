import { ethers } from "hardhat";

async function main() {
  const XENCrypto = await ethers.getContractFactory("XENCrypto");
  const xen = await XENCrypto.deploy();
  await xen.deployed();
  console.log(`XEN deployed: ${xen.address}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
