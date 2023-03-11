// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import { OwnableInternal } from '@solidstate/contracts/access/ownable/OwnableInternal.sol';
import { KnoBlockStorage } from './KnoBlockStorage.sol';
import { OwnableStorage } from '@solidstate/contracts/access/ownable/OwnableStorage.sol';
import { IKnoBlockInternal } from './IKnoBlockInternal.sol';
import { AddressUtils } from '@solidstate/contracts/utils/AddressUtils.sol';

abstract contract KnoBlockInternal is OwnableInternal, IKnoBlockInternal {
    using AddressUtils for address payable;

    uint256 internal constant MAPPING_SLOT = 0;

    constructor() {
        _setOwner(msg.sender);
    }

    /**
     * @notice creates a new KnoBlock
     * @dev utilizes count variable to determine the blockId of the new Block
     * @param unlockAmount the desired Ether Amount for the KnoBlock to Unlock
     * @param knoType the type of information [PDF, MP4, Doc]
     */
    function _create(uint256 unlockAmount, KnoType knoType) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        uint256 blockId = l.count;
        KnoBlockStorage.KnoBlock storage KnoBlock = l.knoBlocks[MAPPING_SLOT][
            blockId
        ];
        KnoBlock.creator = msg.sender;
        KnoBlock.unlockAmount = unlockAmount;
        KnoBlock.knoType = knoType;
        ++l.count;
        emit KnoBlockCreated(blockId);
    }

    /**
     * @notice deposits donation for a given KnoBlock
     * @dev returns potential Overkill of deposit
     * @param blockId the identifier for a KnoBlock Struct
     */
    function _deposit(uint256 blockId) internal {
        KnoBlockStorage.KnoBlock storage KnoBlock = KnoBlockStorage
            .layout()
            .knoBlocks[MAPPING_SLOT][blockId];
        if (KnoBlock.currentAmount == KnoBlock.unlockAmount) {
            revert KnoBlockUnlocked();
        }
        if (KnoBlock.isCancelled == true) {
            revert KnoBlockisCancelled();
        }
        uint256 blockAmount = KnoBlock.currentAmount;
        uint256 unlockAmount = KnoBlock.unlockAmount;
        blockAmount += msg.value;
        KnoBlock.deposits[msg.sender] += msg.value;
        KnoBlock.currentAmount = blockAmount;
        if (blockAmount >= unlockAmount) {
            emit BlockUnlocked(blockId);
        }
        if (blockAmount > unlockAmount) {
            KnoBlock.currentAmount = unlockAmount;
            payable(msg.sender).sendValue(blockAmount - unlockAmount);
        }
    }

    /**
     * @notice withdraws donation from a given KnoBlock
     * @param blockId the identifier for a KnoBlock Struct
     * @param amount the desired withdraw amount
     */
    function _withdraw(uint256 blockId, uint256 amount) internal {
        KnoBlockStorage.KnoBlock storage KnoBlock = KnoBlockStorage
            .layout()
            .knoBlocks[MAPPING_SLOT][blockId];
        if (KnoBlock.currentAmount == KnoBlock.unlockAmount) {
            revert KnoBlockUnlocked();
        }
        if (KnoBlock.deposits[msg.sender] < amount) {
            revert InvalidAmount();
        }
        KnoBlock.currentAmount -= amount;
        KnoBlock.deposits[msg.sender] -= amount;
        payable(msg.sender).sendValue(amount);
    }

    /**
     * @notice cancels a KnoBlock
     * @param blockId the identifier for a KnoBlock Struct
     */
    function _cancel(uint256 blockId) internal {
        KnoBlockStorage.KnoBlock storage KnoBlock = KnoBlockStorage
            .layout()
            .knoBlocks[MAPPING_SLOT][blockId];
        if (KnoBlock.creator != msg.sender) {
            revert NotKnoBlockOwner();
        }
        if (KnoBlock.currentAmount == KnoBlock.unlockAmount) {
            revert KnoBlockUnlocked();
        }
        KnoBlock.isCancelled = true;
    }

    /**
     * @notice for the creater to claim earnings from an Unlocked KnoBlock
     * @param blockId the identifier for a KnoBlock Struct
     */
    function _claim(uint256 blockId) internal {
        KnoBlockStorage.KnoBlock storage KnoBlock = KnoBlockStorage
            .layout()
            .knoBlocks[MAPPING_SLOT][blockId];
        if (KnoBlock.creator != msg.sender) {
            revert NotKnoBlockOwner();
        }
        if (KnoBlock.isCancelled == true) {
            revert KnoBlockisCancelled();
        }
        if (KnoBlock.currentAmount != KnoBlock.unlockAmount) {
            revert KnoBlockLocked();
        }
        KnoBlock.isCancelled = true;
        payable(msg.sender).sendValue(KnoBlock.unlockAmount);
    }

    //views

    /**
     * @notice returns the variable: Count
     */

    function _count() internal view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return l.count;
    }

    function _owned() internal view returns (address) {
        OwnableStorage.Layout storage l = OwnableStorage.layout();
        return l.owner;
    }

    /**
     * @notice returns a KnoBlock's Creator
     * @param blockId the identifier for a KnoBlock Struct
     */
    function _creator(uint256 blockId) internal view returns (address) {
        KnoBlockStorage.KnoBlock storage KnoBlock = KnoBlockStorage
            .layout()
            .knoBlocks[MAPPING_SLOT][blockId];
        return KnoBlock.creator;
    }

    /**
     * @notice returns the total amount for a KnoBlock to Unlock
     * @param blockId the identifier for a KnoBlock Struct
     */
    function _unlockAmount(uint256 blockId) internal view returns (uint256) {
        KnoBlockStorage.KnoBlock storage KnoBlock = KnoBlockStorage
            .layout()
            .knoBlocks[MAPPING_SLOT][blockId];
        return KnoBlock.unlockAmount;
    }

    /**
     * @notice returns the current amount deposited within a KnoBlock
     * @param blockId the identifier for a KnoBlock Struct
     */

    function _currentAmount(uint256 blockId) internal view returns (uint256) {
        KnoBlockStorage.KnoBlock storage KnoBlock = KnoBlockStorage
            .layout()
            .knoBlocks[MAPPING_SLOT][blockId];
        return KnoBlock.currentAmount;
    }

    /**
     * @notice returns the type of information a KnoBlock holds
     * @param blockId the identifier for a KnoBlock Struct
     */

    function _knoType(uint256 blockId) internal view returns (uint256) {
        KnoBlockStorage.KnoBlock storage KnoBlock = KnoBlockStorage
            .layout()
            .knoBlocks[MAPPING_SLOT][blockId];
        return uint256(KnoBlock.knoType);
    }

    /**
     * @notice returns whether a KnoBlock has been cancelled
     * @param blockId the identifier for a KnoBlock Struct
     */

    function _cancelled(uint256 blockId) internal view returns (bool) {
        KnoBlockStorage.KnoBlock storage KnoBlock = KnoBlockStorage
            .layout()
            .knoBlocks[MAPPING_SLOT][blockId];
        return KnoBlock.isCancelled;
    }

    /**
     * @notice returns the amoount msg.sender has deposited in a KnoBlock
     * @param blockId the identifier for a KnoBlock Struct
     */

    function _deposits(uint256 blockId, address account) internal view returns (uint256) {
        KnoBlockStorage.KnoBlock storage KnoBlock = KnoBlockStorage
            .layout()
            .knoBlocks[MAPPING_SLOT][blockId];
        return KnoBlock.deposits[account];
    }
}
