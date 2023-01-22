// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import { OwnableInternal } from '@solidstate/contracts/access/ownable/OwnableInternal.sol';
import { KnoBlockStorage } from './KnoBlockStorage.sol';
import { OwnableStorage } from '@solidstate/contracts/access/ownable/OwnableStorage.sol';
import { IKnoBlockInternal } from './IKnoBlockInternal.sol';

abstract contract KnoBlockInternal is OwnableInternal, IKnoBlockInternal {
    constructor() {
        _setOwner(msg.sender);
    }

    function _createKnoBlock(uint256 unlockValue, KnoType knoType) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        uint256 blockId = l.count;
        l.creator[blockId] = msg.sender;
        l.unlockAmount[blockId] = unlockValue;
        l.currentAmount[blockId] = 0;
        l.knoType[blockId] = knoType;
        l.unlocked[blockId] = false;
        l.deleted[blockId] = false;
        ++l.count;
        emit NewKnoBlock(blockId);
    }

    function _deposit(uint256 blockId) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        if (l.unlocked[blockId] == true) {
            revert KnoBlockUnlocked('KnoBlock is already Unlocked');
        }
        if (l.deleted[blockId] == true) {
            revert KnoBlockDeleted();
        }
        uint256 blockAmount = l.currentAmount[blockId];
        uint256 blockValue = l.unlockAmount[blockId];
        blockAmount += msg.value;
        l.deposits[blockId][msg.sender] += msg.value;
        l.currentAmount[blockId] = blockAmount;
        if (blockAmount >= blockValue) {
            l.unlocked[blockId] = true;
            emit BlockUnlocked(blockId);
        }
        if (blockAmount > blockValue) {
            payable(msg.sender).transfer(blockAmount - blockValue);
            l.currentAmount[blockId] = blockValue;
        }
    }

    //Does not fix a users overkill in deposits, if Knoblock is unlocked
    // (doesnt really matter since he cant withdraw but maybe bad)

    /* function _deposit(uint256 blockId) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        require(l.unlocked[blockId] == false, 'KnoBlock Already Unlocked');
        uint256 previousCurrentAmount = l.currentAmount[blockId];
        l.currentAmount[blockId] += msg.value;
        if (l.currentAmount[blockId] == l.unlockAmount[blockId]) {
            // Would it make sense to reverse these if the second "if" is far more likely??? Yes
            l.unlocked[blockId] = true;
            emit BlockUnlocked(blockId);
        } else if (l.currentAmount[blockId] > l.unlockAmount[blockId]) {
            l.unlocked[blockId] = true;
            payable(msg.sender).transfer(
                l.currentAmount[blockId] - l.unlockAmount[blockId]
            );
            l.currentAmount[blockId] = l.unlockAmount[blockId];
            emit BlockUnlocked(blockId);
        }
        l.deposits[blockId][msg.sender] += (l.currentAmount[blockId] -
            previousCurrentAmount);
    }  */

    function _withdraw(uint256 blockId, uint256 amount) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        if (l.unlocked[blockId] == true) {
            revert KnoBlockUnlocked('KnoBlock is already Unlocked');
        }
        if (l.deposits[blockId][msg.sender] < amount) {
            revert InvalidWithdraw(
                'Invalid Funds',
                l.deposits[blockId][msg.sender]
            );
        }
        l.currentAmount[blockId] -= amount;
        l.deposits[blockId][msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function _delete(uint256 blockId) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        if (l.creator[blockId] != msg.sender) {
            revert NotKnoBlockOwner();
        }
        if (l.unlocked[blockId] == true) {
            revert KnoBlockUnlocked('KnoBlock is already Unlocked');
        }
        l.deleted[blockId] = true;
    }

    function _claim(uint256 blockId) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        if (l.creator[blockId] != msg.sender) {
            revert NotKnoBlockOwner();
        }
        if (l.deleted[blockId] == true) {
            revert KnoBlockDeleted();
        }
        if (l.unlocked[blockId] != true) {
            revert KnoBlockLocked();
        }
        payable(msg.sender).transfer(l.unlockAmount[blockId]);
        l.deleted[blockId] = true;
    }

    //views

    function _getKnoBlock(
        uint256 blockId
    )
        internal
        view
        returns (
            address creator,
            uint256 unlockAmount,
            uint256 currentAmount,
            KnoType knoType,
            bool unlocked
        )
    {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return (
            l.creator[blockId],
            l.unlockAmount[blockId],
            l.currentAmount[blockId],
            l.knoType[blockId],
            l.unlocked[blockId]
        );
    }

    function _returnCount() internal view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return l.count;
    }

    function _returnOwner() internal view returns (address) {
        OwnableStorage.Layout storage l = OwnableStorage.layout();
        return l.owner;
    }

    function _returnKnoBlockCreator(
        uint256 blockId
    ) internal view returns (address) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return l.creator[blockId];
    }

    function _returnKnoBlockUnlockAmount(
        uint256 blockId
    ) internal view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return l.unlockAmount[blockId];
    }

    function _returnKnoBlockCurrentAmount(
        uint256 blockId
    ) internal view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return l.currentAmount[blockId];
    }

    function _returnKnoBlockKnoType(
        uint256 blockId
    ) internal view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return uint256(l.knoType[blockId]);
    }

    function _returnKnoBlockUnlocked(
        uint256 blockId
    ) internal view returns (bool) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return l.unlocked[blockId];
    }

    function _returnKnoBlockDeleted(
        uint256 blockId
    ) internal view returns (bool) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return l.deleted[blockId];
    }

    function _returnKnoBlockDeposits(
        uint256 blockId
    ) internal view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return l.deposits[blockId][msg.sender];
    }
}
