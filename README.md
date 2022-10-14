# Fork MainNet 测试

1. 启动节点  
`npx hardhat node --fork https://eth-goerli.g.alchemy.com/v2/aTJ3B3dN5rkezl-UYjRXLsBsg0yBTXf2`

2. 部署合约  
`npx hardhat run scripts/deploy-all.ts --network localhost`

3. 将部署的合约地址更新到`execute-v2.ts`中  
`npx hardhat run scripts/execute-v2.ts --network localhost`
