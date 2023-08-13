// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

/**
 * @title KnoBlockInternal Interface
 * @notice this interface defines internal events and error types for the KnoBlock Dapp
 * along with a KnoType enum representing the different formats of information.
 */

interface IKnoBlockInternal {
    event KnoBlockCreated(uint256 blockId);
    event BlockUnlocked(uint256 blockId);

    error KnoBlockUnlocked();
    error InvalidAmount();
    error NotKnoBlockOwner();
    error KnoBlockCancelled();
    error KnoBlockLocked();
    error Basis_Exceeded();

    enum KnoType {
        PDF,
        MP4,
        Doc
    }
}
