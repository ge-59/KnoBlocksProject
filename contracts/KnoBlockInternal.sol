// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import { OwnableInternal } from '@solidstate/contracts/access/ownable/OwnableInternal.sol';
import { KnoBlockStorage } from './KnoBlockStorage.sol';
import { OwnableStorage } from '@solidstate/contracts/access/ownable/OwnableStorage.sol';
import { IKnoBlockInternal } from './IKnoBlockInternal.sol';
import { AddressUtils } from '@solidstate/contracts/utils/AddressUtils.sol';

/**
 * @title KnoBlock internal functions
 * @dev inherited by all KnoBlock implementation contracts
 */

abstract contract KnoBlockInternal is OwnableInternal, IKnoBlockInternal {
    using AddressUtils for address payable;

    uint256 internal constant MAPPING_SLOT = 0;
    uint16 internal constant BASIS = 10000;

    constructor() {
        _setOwner(msg.sender);
    }

    /**
     * @notice creates a new KnoBlock
     * @dev utilizes count variable to determine the blockId of the new KnoBlock
     * @param unlockAmount the desired ETH Amount for the KnoBlock to unlock
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
     * @dev returns any excess ETH past unlockAmount
     * @param blockId the identifier for a KnoBlock Struct
     */
    function _deposit(uint256 blockId) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage KnoBlock = l.knoBlocks[MAPPING_SLOT][
            blockId
        ];

        if (KnoBlock.currentAmount == KnoBlock.unlockAmount) {
            revert KnoBlockClosed();
        }
        if (KnoBlock.isCancelled) {
            revert KnoBlockClosed();
        }

        uint256 depositedAmount = msg.value;

        if (l.depositFeeBP != 0) {
            uint256 fee = (depositedAmount * l.depositFeeBP) / BASIS;
            l.accruedFees += fee;
            depositedAmount -= fee;
        }

        uint256 currentAmount = KnoBlock.currentAmount;
        uint256 unlockAmount = KnoBlock.unlockAmount;
        currentAmount += depositedAmount;
        KnoBlock.deposits[msg.sender] += depositedAmount;
        KnoBlock.currentAmount = currentAmount;

        if (currentAmount >= unlockAmount) {
            emit KnoBlockUnlocked(blockId);
        }

        if (currentAmount > unlockAmount) {
            KnoBlock.currentAmount = unlockAmount;
            payable(msg.sender).sendValue(currentAmount - unlockAmount);
        }
    }

    /**
     * @notice withdraws user deposit from a given KnoBlock
     * @param blockId the identifier for a KnoBlock Struct
     * @param amount the desired withdraw amount
     */
    function _withdraw(uint256 blockId, uint256 amount) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage KnoBlock = l.knoBlocks[MAPPING_SLOT][
            blockId
        ];
        if (KnoBlock.currentAmount == KnoBlock.unlockAmount) {
            revert KnoBlockClosed();
        }
        if (KnoBlock.deposits[msg.sender] < amount) {
            revert InvalidAmount();
        }

        KnoBlock.currentAmount -= amount;
        KnoBlock.deposits[msg.sender] -= amount;

        if (l.withdrawFeeBP != 0) {
            uint256 fee = (amount * l.withdrawFeeBP) / BASIS;
            l.accruedFees += fee;
            amount -= fee;
        }

        payable(msg.sender).sendValue(amount);
    }

    /**
     * @notice permenantly cancels a KnoBlock, allowing no actions other than deposit withdrawls by users
     * @param blockId the identifier for a KnoBlock Struct
     */
    function _cancel(uint256 blockId) internal {
        KnoBlockStorage.KnoBlock storage KnoBlock = KnoBlockStorage
            .layout()
            .knoBlocks[MAPPING_SLOT][blockId];
        if (KnoBlock.creator != msg.sender) {
            revert OnlyKnoBlockOwner();
        }
        if (KnoBlock.currentAmount == KnoBlock.unlockAmount) {
            revert KnoBlockClosed();
        }
        KnoBlock.isCancelled = true;
    }

    /**
     * @notice for the creater to claim earnings from an unlocked KnoBlock
     * @param blockId the identifier for a KnoBlock Struct
     */
    function _claim(uint256 blockId) internal {
        KnoBlockStorage.KnoBlock storage KnoBlock = KnoBlockStorage
            .layout()
            .knoBlocks[MAPPING_SLOT][blockId];
        if (KnoBlock.creator != msg.sender) {
            revert OnlyKnoBlockOwner();
        }
        if (KnoBlock.isCancelled) {
            revert KnoBlockClosed();
        }
        if (KnoBlock.currentAmount != KnoBlock.unlockAmount) {
            revert KnoBlockLocked();
        }
        KnoBlock.isCancelled = true;
        payable(msg.sender).sendValue(KnoBlock.unlockAmount);
    }

    //Admin Functions

    /**
     * @notice for admin to set the withdrawFee in BASIS
     * @param feeBP the percentage fee in BASIS points
     */
    function _setWithdrawFeeBP(uint256 feeBP) internal onlyOwner {
        if (feeBP > 10000) {
            revert Basis_Exceeded();
        }
        KnoBlockStorage.layout().withdrawFeeBP = feeBP;
    }

    /**
     * @notice for admin to set the depositFee in BASIS
     * @param feeBP the percentage fee in BASIS points
     */
    function _setDepositFeeBP(uint256 feeBP) internal onlyOwner {
        if (feeBP > 10000) {
            revert Basis_Exceeded();
        }
        KnoBlockStorage.layout().depositFeeBP = feeBP;
    }

    /**
     * @notice for admin to withdraw the fees earned
     */

    function _withdrawFees() internal onlyOwner {
        payable(msg.sender).sendValue(KnoBlockStorage.layout().accruedFees);
    }

    //View Functions

    /**
     * @notice returns the variable: Count, used to set KnoBlock ID's
     */

    function _count() internal view returns (uint256 num) {
        return KnoBlockStorage.layout().count;
    }

    /**
     * @notice returns a KnoBlock's Creator address
     * @param blockId the identifier for a KnoBlock Struct
     */

    function _creator(uint256 blockId) internal view returns (address blocker) {
        return
            KnoBlockStorage.layout().knoBlocks[MAPPING_SLOT][blockId].creator;
    }

    /**
     * @notice returns the total amount of ETH required for a KnoBlock to unlock
     * @param blockId the identifier for a KnoBlock Struct
     */
    function _unlockAmount(
        uint256 blockId
    ) internal view returns (uint256 amount) {
        return
            KnoBlockStorage
            .layout()
            .knoBlocks[MAPPING_SLOT][blockId].unlockAmount;
    }

    /**
     * @notice returns the current amount deposited within a KnoBlock
     * @param blockId the identifier for a KnoBlock Struct
     */

    function _currentAmount(
        uint256 blockId
    ) internal view returns (uint256 amount) {
        return
            KnoBlockStorage
            .layout()
            .knoBlocks[MAPPING_SLOT][blockId].currentAmount;
    }

    /**
     * @notice returns the type of information a KnoBlock holds
     * @param blockId the identifier for a KnoBlock Struct
     */

    function _knoType(uint256 blockId) internal view returns (uint256 format) {
        return
            uint256(
                KnoBlockStorage
                .layout()
                .knoBlocks[MAPPING_SLOT][blockId].knoType
            );
    }

    /**
     * @notice returns whether a KnoBlock has been closed (cancelled or completed)
     * @param blockId the identifier for a KnoBlock Struct
     */

    function _cancelled(uint256 blockId) internal view returns (bool status) {
        return
            KnoBlockStorage
            .layout()
            .knoBlocks[MAPPING_SLOT][blockId].isCancelled;
    }

    /**
     * @notice returns the amount msg.sender has deposited in a KnoBlock
     * @param blockId the identifier for a KnoBlock Struct
     */

    function _deposits(
        uint256 blockId,
        address account
    ) internal view returns (uint256 amount) {
        return
            KnoBlockStorage.layout().knoBlocks[MAPPING_SLOT][blockId].deposits[
                account
            ];
    }

    /**
     * @notice returns the current withdrawFee in BASIS
     */
    function _withdrawFeeBP() internal view returns (uint256 feeBP) {
        return KnoBlockStorage.layout().withdrawFeeBP;
    }

    /**
     * @notice returns the current depositFee in BASIS
     */
    function _depositFeeBP() internal view returns (uint256 feeBP) {
        return KnoBlockStorage.layout().depositFeeBP;
    }

    /**
     * @notice returns the current amount of ETH accumulated from fees
     */
    function _feesCollected() internal view returns (uint256 total) {
        return KnoBlockStorage.layout().accruedFees;
    }
}
