import { ethers } from "hardhat";
import { time } from "@nomicfoundation/hardhat-network-helpers";
import { expect } from "chai";
import CollectionABI from "./Collection.json";
let FeeTokenAddress: any;
let FeeToken: any;
let Marketplace: any;
let Marketplace_Address: any;
let Factory: any;
let Factory_Address: any;
let owner: any;
let user1: any;
let user2: any;
let user3: any;
let developmentTeam: any;
let buyer1: any;
let buyer2: any;
const percentForSeller: number = 85;
const mintFee: number = 0;
const burnFee: number = 0;
describe("Create Initial Contracts of all types", function () {
  it("get accounts", async function () {
    [owner, user1, user2, developmentTeam, buyer1, buyer2, user3] =
      await ethers.getSigners();
    console.log("\tAccount address\t", await owner.getAddress());
  });
  it("should deploy FeeToken Contract", async function () {
    const instanceFeeToken = await ethers.getContractFactory("MarsWTF");
    FeeToken = await instanceFeeToken.deploy();
    FeeTokenAddress = await FeeToken.getAddress();
    console.log("\tFeeToken Contract deployed at:", FeeTokenAddress);
  });
  it("should deploy Factory Contract", async function () {
    const instanceGroup = await ethers.getContractFactory("CreatorGroup");
    const Group = await instanceGroup.deploy();
    const Group_Address = await Group.getAddress();
    const instanceContent = await ethers.getContractFactory("ContentNFT");
    const Content = await instanceContent.deploy();
    const Content_Address = await Content.getAddress();
    const instanceFactory = await ethers.getContractFactory("Factory");
    Factory = await instanceFactory.deploy(
      Group_Address,
      Content_Address,
      Marketplace_Address,
      developmentTeam,
      mintFee,
      burnFee,
      USDC_Address
    );
    Factory_Address = await Factory.getAddress();
    console.log("\tFactory Contract deployed at:", Factory_Address);
  });
});
