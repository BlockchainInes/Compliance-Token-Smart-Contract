# Compliance-Token-Smart-Contract

An ERC-20 token implementation featuring an integrated KYC/Compliance whitelist to ensure regulated asset transfers.

## 🎯 Project Overview
This project demonstrates a regulatory-compliant smart contract solution. It features a custom **Compliance Gate** that restricts token transfers to verified addresses only.

## 🛠 Tech Stack
* **Language:** Solidity ^0.8.20
* **Standards:** OpenZeppelin ERC-20
* **IDE:** Remix (VM Osaka)

## 🧪 Proof of Concept (Security Test)
The core logic of this contract is to protect the asset by blocking unauthorized transactions.

### Test Case: Unauthorized Transfer (Rejected)
As shown in the screenshot below, the transaction is automatically reverted by the blockchain because the recipient is not yet KYC-verified.

![Compliance Error Screenshot](Captura de pantalla 2026-03-05 193158.png)

* **Result:** The contract successfully triggered the error message: `"Compliance Error: Empfaenger nicht verifiziert (KYC)"`.
