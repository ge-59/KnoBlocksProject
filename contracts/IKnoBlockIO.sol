// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { IKnoBlockInternal } from './IKnoBlockInternal.sol';

/**
 * @title KnoBlockIO Interface
 * @notice this interface defines the user input and output functions of the KnoBlock Dapp
 */
interface IKnoBlockIO is IKnoBlockInternal {
    /**
     * @notice creates a new KnoBlock
     * @dev utilizes count variable to determine the blockId of the new KnoBlock
     * @param unlockAmount the desired ETH Amount for the KnoBlock to unlock
     * @param knoType the type of information [PDF, MP4, Doc]
     */
    function create(uint256 unlockAmount, KnoType knoType) external payable;

    /**
     * @notice deposits donation for a given KnoBlock
     * @dev returns any excess ETH past unlockAmount
     * @param blockId the identifier for a KnoBlock Struct
     */
    function deposit(uint256 blockId) external payable;

    /**
     * @notice withdraws user deposit from a given KnoBlock
     * @param blockId the identifier for a KnoBlock Struct
     * @param amount the desired withdraw amount
     */
    function withdraw(uint256 blockId, uint256 amount) external;

    /**
     * @notice permenantly cancels a KnoBlock, allowing no actions other than deposit withdrawls by users
     * @param blockId the identifier for a KnoBlock Struct
     */
    function cancel(uint256 blockId) external;

    /**
     * @notice for the creater to claim earnings from an unlocked KnoBlock
     * @param blockId the identifier for a KnoBlock Struct
     */
    function claim(uint256 blockId) external;
}
