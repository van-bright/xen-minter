import { ethers } from "hardhat";

async function main() {
  const XENCrypto = await ethers.getContractFactory("XENCrypto");
  const xen = await XENCrypto.deploy();
  await xen.deployed();
  console.log(`XEN deployed: ${xen.address}`);

  const BatcherV2 = await ethers.getContractFactory("BatcherV2");
  const v2 = await BatcherV2.deploy(xen.address);
  await v2.deployed();
  console.log(`BatcherV2 deployed: ${v2.address}`);

  // 创建100个proxy
  await v2.createProxies(100);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
