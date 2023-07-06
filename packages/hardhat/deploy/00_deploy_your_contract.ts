import { HardhatRuntimeEnvironment } from "hardhat/types";
import { DeployFunction } from "hardhat-deploy/types";
import { ethers } from "hardhat";

const deployYourContract: DeployFunction = async function (hre: HardhatRuntimeEnvironment) {
  const { deployer } = await hre.getNamedAccounts();
  const { deploy } = hre.deployments;

  const deployment = await deploy("EscrowFactory", {
    from: deployer,
    log: true,
  });

  // Get the deployed contract
  const escrowFactory = await ethers.getContractAt("EscrowFactory", deployment.address);

  // Specify the arbiter, beneficiary, and salt for the escrow creation
  const arbiter = deployer; // Adjust as necessary for your use case
  const beneficiary = deployer; // Adjust as necessary for your use case
  const salt = ethers.utils.formatBytes32String("random"); // Or however you generate your salt

  // Create the salted escrow contract
  const escrowAddress = await escrowFactory.createEscrow(arbiter, beneficiary, salt, {
    value: ethers.utils.parseEther("1"),
  });

  console.log(`Escrow created at address: ${escrowAddress}`);
};

export default deployYourContract;

deployYourContract.tags = ["EscrowFactory"];
