
// Importing necessary functionalities from the Hardhat package.
import { ethers } from 'hardhat'

async function main() {
    // Retrieve the first signer, typically the default account in Hardhat, to use as the deployer.
    const [deployer] = await ethers.getSigners();
    const instanceMyToken = await ethers.deployContract("MyToken", [10000000000]);
    await instanceMyToken.waitForDeployment()
    const MyToken_Address = await instanceMyToken.getAddress();
    console.log(`Factory is deployed. ${MyToken_Address}`);
}

// This pattern allows the use of async/await throughout and ensures that errors are caught and handled properly.
main().catch(error => {
    console.error(error)
    process.exitCode = 1
})