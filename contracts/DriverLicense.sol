// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/access/AccessControl.sol";

contract DriverLicense is ERC721, AccessControl {
    bytes32 public constant REGISTRO_CIVIL_ROLE = keccak256("REGISTRO_CIVIL_ROLE");

    struct LicenseData {
        string classType;
        uint64 expiry;
        bool active;
    }

    // tokenId => LicenseData
    mapping(uint256 => LicenseData) public licenses;

    uint256 public nextId;

    constructor(address registroCivil) ERC721("DriverLicense", "DL") {
        _grantRole(DEFAULT_ADMIN_ROLE, msg.sender);
        _grantRole(REGISTRO_CIVIL_ROLE, registroCivil);
    }

    // Soulbound behavior: block all transfers except mint/burn
    function _update(address to, uint256 tokenId, address auth)
        internal
        override
        returns (address)
    {
        // Only allow minting (from = 0) or burning (to = 0)
        if (to != address(0) && _ownerOf(tokenId) != address(0)) {
            revert("Soulbound: Non-transferable");
        }
        return super._update(to, tokenId, auth);
    }

    function issueLicense(
        address driver,
        string calldata classType,
        uint64 expiry
    ) external onlyRole(REGISTRO_CIVIL_ROLE) returns (uint256) {
        uint256 tokenId = ++nextId;
        _mint(driver, tokenId);
        licenses[tokenId] = LicenseData(classType, expiry, true);
        return tokenId;
    }

    function revokeLicense(uint256 tokenId) external onlyRole(REGISTRO_CIVIL_ROLE) {
        licenses[tokenId].active = false;
    }

    function getMyLicense(address driver) external view returns (LicenseData memory) {
        uint256 balance = balanceOf(driver);
        require(balance > 0, "Driver has no license");
        for (uint256 i = 1; i <= nextId; i++) {
            if (ownerOf(i) == driver) return licenses[i];
        }
        revert("License not found");
    }

    // Required override for multiple inheritance (ERC165)
    function supportsInterface(bytes4 interfaceId)
        public
        view
        override(ERC721, AccessControl)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }
}
