const { ethers } = require("hardhat");

async function main() {
  const [deployer, regCivil, muni, aseg, planta] = await ethers.getSigners();

  console.log("Registro Civil:", regCivil.address);
  console.log("Municipalidad:", muni.address);
  console.log("Aseguradora:", aseg.address);
  console.log("Planta:", planta.address);

  const Contract = await ethers.getContractFactory("VehicleRegistry");
  const registry = await Contract.deploy(
    regCivil.address,
    muni.address,
    aseg.address,
    planta.address
  );

  await registry.waitForDeployment();

  console.log("Contrato desplegado en:", await registry.getAddress());
}

main().catch(console.error);
