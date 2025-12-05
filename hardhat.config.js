require("@nomicfoundation/hardhat-toolbox");
require("dotenv").config();

module.exports = {
  solidity: "0.8.20",

  networks: {
    fuji: {
      url: process.env.RPC_AVALANCHE_FUJI,
      accounts: [
        process.env.PRIVATE_KEY_DEPLOYER,
        process.env.PRIVATE_KEY_REGISTRO,
        process.env.PRIVATE_KEY_MUNI,
        process.env.PRIVATE_KEY_ASEG,
        process.env.PRIVATE_KEY_PLANTA
      ]
    }
  }
};
