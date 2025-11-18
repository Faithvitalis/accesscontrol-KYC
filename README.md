# Access Control KYC Contract

This is a **KYC Mock Registry Contract** written in Clarity for the Stacks blockchain. It demonstrates access control patterns, principal ownership, and map storage for on-chain records. The contract allows an admin to verify or revoke the verification status of user addresses, with additional functionality for querying verification status and transferring admin privileges.

## Features

- **Admin Role**: The deployer of the contract is the default admin, with the ability to transfer the role to another principal.
- **User Verification**: Admins can verify or revoke the verification status of user addresses.
- **Access Control**: Only the admin can perform state-changing operations.
- **Query Verification Status**: Anyone can check if a user is verified.
- **Error Handling**: Uses `asserts!` for access control and error reporting.
- **Upgradable Admin Role**: Admin privileges can be transferred to another principal.

## Contract Overview

### State Variables

1. **Admin**: The principal (address) with admin privileges.
2. **Verified Users Map**: A map that stores the verification status of user addresses.

### Public Functions

1. **`verify-user`**: Marks a user as verified (admin-only).
2. **`revoke-user`**: Marks a user as unverified (admin-only).
3. **`transfer-admin`**: Transfers admin privileges to another principal (admin-only).

### Read-Only Functions

1. **`is-verified`**: Checks if a user is verified.
2. **`get-admin`**: Returns the current admin principal.

## Usage

### Deployment

Deploy the contract to the Stacks blockchain using the Clarity CLI or a compatible development environment like [Clarinet](https://github.com/hirosystems/clarinet).

### Example Calls

#### Verify a User
```clarity
(contract-call? .accesscontrol-KYC verify-user 'SP2C2...XYZ)
