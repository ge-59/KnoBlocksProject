// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

/**
 * @title KnoBlockInternal Interface
 * @notice this interface defines internal events and error types for the KnoBlock Dapp
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
     * @param blockId the identifier of the KnoBlock
     */
    event BlockUnlocked(uint256 blockId);

    /**
     * @dev error thrown when trying to interact with a complete KnoBlock as if it is incomplete
     */
    error KnoBlockUnlocked();

    /**
     * @dev error thrown when trying to interact with an incomplete KnoBlock as if it is complete
     */
    error KnoBlockLocked();

    /**
     * @dev error thrown when the user inputs an amount that is not valid
     */
    error InvalidAmount();

    /**
     * @dev error thrown when the caller is not the owner of the KnoBlock
     */
    error NotKnoBlockOwner();

    /**
     * @dev error thrown when trying to interact with a cancelled KnoBlock
     */
    error KnoBlockCancelled();

    /**
     * @dev error thrown when the BASIS is exceeded
     */
    error Basis_Exceeded();

    /**
     * @dev enumeration representing different formats of information contained within
     */
    enum KnoType {
        PDF,
        MP4,
        Doc
    }
}
