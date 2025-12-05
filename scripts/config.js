require("dotenv").config();

module.exports = {
  deployer: process.env.PRIVATE_KEY_DEPLOYER,
  registroCivil: process.env.PRIVATE_KEY_REGISTRO,
  municipalidad: process.env.PRIVATE_KEY_MUNI,
  aseguradora: process.env.PRIVATE_KEY_ASEG,
  plantaRT: process.env.PRIVATE_KEY_PLANTA
};
