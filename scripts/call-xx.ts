

import delay from "delay";
import { ethers } from "hardhat";

const XXADDR = '0x4ce5ff1930918DEbBEaC903BC214ebC2c54AF06e';
async function main() {
  const xx = await ethers.getContractAt('XX', XXADDR);

//   await xx.execute(0, 50, "0x9f8fc873d5191e34d7eb7b8f91f53824976c0fea", {gasLimit: 14000000});
//   await delay(2000);
//   await xx.execute(50, 50, "0x9f8fc873d5191e34d7eb7b8f91f53824976c0fea", {gasLimit: 14000000});
//   await delay(2000);
  await xx.execute(0, 100, "0x9f8fc873d5191e34d7eb7b8f91f53824976c0fea", {gasLimit: 14000000});

  const XEN = await ethers.getContractAt('XENCrypto', "0x606F8d5e36AF652DAdBc011bac916f6cb57e17eB");


  console.log(`balanceOf: ${await XEN.balanceOf('0x9f8fc873d5191e34d7eb7b8f91f53824976c0fea')}`);
}

// We recommend this pattern to be able to use async/await everywhere
// and properly handle errors.
main().catch((error) => {
  console.error(error);
  process.exitCode = 1;
});
