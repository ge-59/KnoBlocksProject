// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { KnoBlockInternal } from './KnoBlockInternal.sol';

abstract contract IKnoBlockIO is KnoBlockInternal {
    
  /**
 * @notice Creates a new KnoBlock
 * @dev Utilizes count variable to determine the blockId of the new Block
 * @param unlockValue The desired Ether Amount for the KnoBlock to Unlock
 * @param knoType The type of information [PDF, MP4, Doc]
 */  
    function create(uint256 unlockValue, KnoType knoType) external virtual payable;
/**
 * @notice Deposits donation for a given KnoBlock
 * @dev Returns potential Overkill of deposit
 * @param blockId The identifier for a KnoBlock Struct
 */
    function deposit(uint256 blockId) external virtual payable;
/**
     * @notice Withdraws donation from a given KnoBlock
     * @param blockId The identifier for a KnoBlock Struct
     * @param amount The desired withdraw amount
     */
    function withdraw(uint256 blockId, uint256 amount) external virtual;
/**
 * @notice Cancels a KnoBlock
 * @param blockId The identifier for a KnoBlock Struct
 */
    function cancel(uint256 blockId) external virtual;
/**
 * @notice For the creater to claim earnings from an Unlocked KnoBlock
 * @param blockId The identifier for a KnoBlock Struct
 */
    function claim(uint256 blockId) external virtual;
}
