// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract VehicleRegistry is ERC721, AccessControl {
    bytes32 public constant REGISTRO_CIVIL_ROLE = keccak256("REGISTRO_CIVIL_ROLE");
    bytes32 public constant MUNICIPALIDAD_ROLE = keccak256("MUNICIPALIDAD_ROLE");
    bytes32 public constant ASEGURADORA_ROLE = keccak256("ASEGURADORA_ROLE");
    bytes32 public constant PLANTA_REVISION_ROLE = keccak256("PLANTA_REVISION_ROLE");

    struct VehicleData {
        string plate;
        uint16 year;
        bytes32 metadataHash;
    }

    struct Document {
        string name;
        uint256 issuedAt;
        bytes32 ipfsHash; 
    }

    mapping(uint256 => VehicleData) public vehicles;

    mapping(uint256 => Document) public soap;       // Seguro obligatorio
    mapping(uint256 => Document) public permiso;    // Permiso de circulación
    mapping(uint256 => Document) public revision;   // Revisión técnica

    uint256 public nextId;

    constructor(
        address registroCivil,
        address municipalidad,
        address aseguradora,
        address planta
    ) ERC721("VehicleNFT", "VHCL") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(REGISTRO_CIVIL_ROLE, registroCivil);
        _grantRole(MUNICIPALIDAD_ROLE, municipalidad);
        _grantRole(ASEGURADORA_ROLE, aseguradora);
        _grantRole(PLANTA_REVISION_ROLE, planta);
    }

    // ------------------------------
    // VEHÍCULOS
    // ------------------------------

    function mintVehicle(
        address owner,
        string calldata plate,
        uint16 year,
        bytes32 metadataHash
    ) external onlyRole(REGISTRO_CIVIL_ROLE) returns (uint256) {
        uint256 tokenId = ++nextId;
        vehicles[tokenId] = VehicleData(plate, year, metadataHash);
        _mint(owner, tokenId);
        return tokenId;
    }

    function transferPadron(address from, address to, uint256 tokenId)
        external
        onlyRole(REGISTRO_CIVIL_ROLE)
    {
        _transfer(from, to, tokenId);
    }

    // ------------------------------
    // DOCUMENTOS
    // ------------------------------

    function emitirSOAP(uint256 tokenId, bytes32 ipfsHash)
        external
        onlyRole(ASEGURADORA_ROLE)
    {
        soap[tokenId] = Document("SOAP", block.timestamp, ipfsHash);
    }

    function emitirPermiso(uint256 tokenId, bytes32 ipfsHash)
        external
        onlyRole(MUNICIPALIDAD_ROLE)
    {
        permiso[tokenId] = Document("Permiso Circulacion", block.timestamp, ipfsHash);
    }

    function emitirRevisionTecnica(uint256 tokenId, bytes32 ipfsHash)
        external
        onlyRole(PLANTA_REVISION_ROLE)
    {
        revision[tokenId] = Document("Revision Tecnica", block.timestamp, ipfsHash);
    }
    function tieneRol(bytes32 role, address cuenta) public view returns (bool) {
        return hasRole(role, cuenta);
    }


    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
