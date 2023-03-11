// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import {IKnoBlockInternal} from './IKnoBlockInternal.sol';

interface IKnoBlockIO is IKnoBlockInternal{
    /**
     * @notice creates a new KnoBlock
     * @dev utilizes count variable to determine the blockId of the new Block
     * @param unlockAmount the desired Ether Amount for the KnoBlock to Unlock
     * @param knoType the type of information [PDF, MP4, Doc]
     */
    function create(
        uint256 unlockAmount,
        KnoType knoType
    ) external payable;

    /**
     * @notice deposits donation for a given KnoBlock
     * @dev returns potential Overkill of deposit
     * @param blockId the identifier for a KnoBlock Struct
     */
    function deposit(uint256 blockId) external payable virtual;

    /**
     * @notice withdraws donation from a given KnoBlock
     * @param blockId the identifier for a KnoBlock Struct
     * @param amount the desired withdraw amount
     */
    function withdraw(uint256 blockId, uint256 amount) external virtual;

    /**
     * @notice cancels a KnoBlock
     * @param blockId the identifier for a KnoBlock Struct
     */
    function cancel(uint256 blockId) external virtual;

    /**
     * @notice for the creater to claim earnings from an Unlocked KnoBlock
     * @param blockId the identifier for a KnoBlock Struct
     */
    function claim(uint256 blockId) external virtual;
}
