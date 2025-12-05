// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/access/AccessControl.sol";

contract VehicleDocuments is AccessControl {
    bytes32 public constant MUNICIPALIDAD_ROLE = keccak256("MUNICIPALIDAD_ROLE");
    bytes32 public constant ASEGURADORA_ROLE   = keccak256("ASEGURADORA_ROLE");
    bytes32 public constant PLANTA_RT_ROLE     = keccak256("PLANTA_RT_ROLE");

    struct DocInfo {
        bytes32 docHash;    // hash del PDF/JSON
        uint64  expiry;     // timestamp UNIX
        bool    valid;
    }

    // tokenId (del vehículo) => docs
    struct VehicleDocs {
        DocInfo permisoCirculacion;
        DocInfo seguro;
        DocInfo revisionTecnica;
        DocInfo emisiones;
    }

    mapping(uint256 => VehicleDocs) public vehicleDocs;

    constructor(address muni, address aseg, address planta) {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(MUNICIPALIDAD_ROLE, muni);
        _grantRole(ASEGURADORA_ROLE, aseg);
        _grantRole(PLANTA_RT_ROLE, planta);
    }

    // ---- setters (ficticios, solo roles especiales) ----

    function setPermisoCirculacion(
        uint256 vehicleId,
        bytes32 docHash,
        uint64 expiry,
        bool valid
    ) external onlyRole(MUNICIPALIDAD_ROLE) {
        vehicleDocs[vehicleId].permisoCirculacion = DocInfo(docHash, expiry, valid);
    }

    function setSeguro(
        uint256 vehicleId,
        bytes32 docHash,
        uint64 expiry,
        bool valid
    ) external onlyRole(ASEGURADORA_ROLE) {
        vehicleDocs[vehicleId].seguro = DocInfo(docHash, expiry, valid);
    }

    function setRevisionTecnica(
        uint256 vehicleId,
        bytes32 docHash,
        uint64 expiry,
        bool valid
    ) external onlyRole(PLANTA_RT_ROLE) {
        vehicleDocs[vehicleId].revisionTecnica = DocInfo(docHash, expiry, valid);
    }

    function setEmisiones(
        uint256 vehicleId,
        bytes32 docHash,
        uint64 expiry,
        bool valid
    ) external onlyRole(PLANTA_RT_ROLE) {
        vehicleDocs[vehicleId].emisiones = DocInfo(docHash, expiry, valid);
    }

    // lecturas públicas (Carabineros, dueños, etc.)
    function getAllDocs(uint256 vehicleId) external view returns (VehicleDocs memory) {
        return vehicleDocs[vehicleId];
    }
}
