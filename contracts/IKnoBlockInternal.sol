// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

/**
 * @title KnoBlockInternal Interface
 * @notice this interface contains events and error types for the KnoBlock Dapp
 * along with a KnoType enum representing the different formats of information.
 */

interface IKnoBlockInternal {
    /**
     * @dev emitted when a new KnoBlock is created
     * @param blockId the unique identifier of the KnoBlock
     */
    event KnoBlockCreated(uint256 blockId);

    /**
     * @dev emitted when a KnoBlock is unlocked
     * @param blockId the unique identifier of the KnoBlock
     */
    event KnoBlockUnlocked(uint256 blockId);

    /**
     * @dev error thrown when attempting actions that are unable to be executed on a cancelled or complete KnoBlock
     */
    error KnoBlockClosed();

    /**
     * @dev error thrown when attempting actions that are unable to be executed on an incomplete KnoBlock
     */
    error KnoBlockLocked();

    /**
     * @dev error thrown when the user attempts to withdraw more than they have deposited
     */
    error AmountExceedsDeposit();

    /**
     * @dev error thrown when the caller is not the owner of the KnoBlock
     */
    error OnlyKnoBlockOwner();

    /**
     * @dev error thrown when the BASIS is exceeded
     */
    error Basis_Exceeded();

    /**
     * @dev enumeration representing different formats of information contained within a KnoBlock
     */
    enum KnoType {
        PDF,
        MP4,
        Doc
    }
}
