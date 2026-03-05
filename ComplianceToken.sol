// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

/**
 * @title RWA Compliance Gate
 * @dev Dieses Projekt zeigt, wie man den Transfer von Assets an eine Whitelist (KYC) bindet.
 */

// Importiert die Industriestandards direkt von OpenZeppelin
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.0/contracts/token/ERC20/ERC20.sol";
import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v5.0.0/contracts/access/Ownable.sol";

contract ComplianceToken is ERC20, Ownable {

    // Mapping, um zu speichern, welche Adresse verifiziert (whitelisted) ist
    mapping(address => bool) public isWhitelisted;

    // Event, das ausgelöst wird, wenn sich der Status einer Adresse ändert
    event WhitelistUpdated(address indexed account, bool status);

    // Erstellt den Token mit Namen "RWA Asset" und Symbol "RWA"
    constructor() ERC20("RWA Asset", "RWA") Ownable(msg.sender) {
        // Der Ersteller des Contracts (du!) wird automatisch gewhitelistet
        isWhitelisted[msg.sender] = true;
    }

    /**
     * @dev Funktion zum Hinzufügen/Entfernen von Adressen zur Whitelist.
     * Nur der Besitzer (Owner) kann diese Funktion aufrufen.
     */
    function setWhitelist(address _account, bool _status) external onlyOwner {
        isWhitelisted[_account] = _status;
        emit WhitelistUpdated(_account, _status);
    }

    /**
     * @dev Hier wird der "Gate-Mechanismus" implementiert.
     * Vor jedem Transfer prüft der Contract, ob Sender und Empfänger verifiziert sind.
     */
    function _update(address from, address to, uint256 value) internal override {
        // Wenn es kein "Minting" (Erstellung) ist, muss der Sender verifiziert sein
        if (from != address(0)) {
            require(isWhitelisted[from], "Compliance Error: Sender nicht verifiziert (KYC)");
        }
        
        // Wenn es kein "Burning" (Löschen) ist, muss der Empfaenger verifiziert sein
        if (to != address(0)) {
            require(isWhitelisted[to], "Compliance Error: Empfaenger nicht verifiziert (KYC)");
        }

        // Führt den eigentlichen Transfer aus, wenn die Bedingungen erfüllt sind
        super._update(from, to, value);
    }

    /**
     * @dev Erstellt neue Tokens. Nur der Owner kann das.
     */
    function mint(address to, uint256 amount) external onlyOwner {
        _mint(to, amount);
    }
}
