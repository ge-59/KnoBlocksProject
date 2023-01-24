// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import { OwnableInternal } from '@solidstate/contracts/access/ownable/OwnableInternal.sol';
import { KnoBlockStorage } from './KnoBlockStorage.sol';
import { OwnableStorage } from '@solidstate/contracts/access/ownable/OwnableStorage.sol';
import { IKnoBlockInternal } from './IKnoBlockInternal.sol';

abstract contract KnoBlockInternal is OwnableInternal, IKnoBlockInternal {
    uint256 internal constant MAPPING_SLOT = 0;
    
    constructor() {
        _setOwner(msg.sender);
    }

    function getBlock(uint256 blockId) internal returns (KnoBlock storage block) {
    BlockStorage.Layout storage l = BlockStorage.layout();

    block = l.myMapping[MAPPING_SLOT][blockId];
}

    function _createKnoBlock(uint256 unlockValue, KnoType knoType) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        uint256 blockId = l.count;
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockId];
        myKnoBlock.creator = msg.sender;
        myKnoBlock.unlockAmount = unlockValue;
        myKnoBlock.currentAmount = 0;
        myKnoBlock.knoType = knoType;
        ++l.count;
        emit NewKnoBlock(blockId);
    }

    function _deposit(uint256 blockId) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockId];
        if (myKnoBlock.Unlocked == true) {
            revert KnoBlockUnlocked('KnoBlock is already Unlocked');
        }
        if (myKnoBlock.Deleted == true) {
            revert KnoBlockDeleted();
        }
        uint256 blockAmount = myKnoBlock.currentAmount;
        uint256 blockValue = myKnoBlock.unlockAmount;
        blockAmount += msg.value;
        myKnoBlock.deposits[msg.sender] += msg.value;
        myKnoBlock.currentAmount = blockAmount;
        if (blockAmount >= blockValue) {
            myKnoBlock.Unlocked  = true;
            emit BlockUnlocked(blockId);
        }
        if (blockAmount > blockValue) {
            payable(msg.sender).transfer(blockAmount - blockValue);
            myKnoBlock.currentAmount  = blockValue;
        }
    }

    //Does not fix a users overkill in deposits, if Knoblock is unlocked
    // (doesnt really matter since he cant withdraw but maybe bad)

    /* function _deposit(uint256 blockId) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        require(myKnoBlock.Unlocked[blockId] == false, 'KnoBlock Already Unlocked');
        uint256 previousCurrentAmount = myKnoBlock.currentAmount[blockId];
        myKnoBlock.currentAmount[blockId] += msg.value;
        if (myKnoBlock.currentAmount[blockId] == myKnoBlock.unlockAmount[blockId]) {
            // Would it make sense to reverse these if the second "if" is far more likely??? Yes
            myKnoBlock.Unlocked[blockId] = true;
            emit BlockUnlocked(blockId);
        } else if (myKnoBlock.currentAmount[blockId] > myKnoBlock.unlockAmount[blockId]) {
            myKnoBlock.Unlocked[blockId] = true;
            payable(msg.sender).transfer(
                myKnoBlock.currentAmount[blockId] - myKnoBlock.unlockAmount[blockId]
            );
            myKnoBlock.currentAmount[blockId] = myKnoBlock.unlockAmount[blockId];
            emit BlockUnlocked(blockId);
        }
        myKnoBlock.deposits[blockId][msg.sender] += (myKnoBlock.currentAmount[blockId] -
            previousCurrentAmount);
    }  */

    function _withdraw(uint256 blockId, uint256 amount) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockId];
        if (myKnoBlock.Unlocked == true) {
            revert KnoBlockUnlocked('KnoBlock is already Unlocked');
        }
        if (myKnoBlock.deposits[msg.sender] < amount) {
            revert InvalidWithdraw(
                'Invalid Funds',
                myKnoBlock.deposits[msg.sender]
            );
        }
        myKnoBlock.currentAmount -= amount;
        myKnoBlock.deposits[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }

    function _delete(uint256 blockId) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockId];
        if (myKnoBlock.creator != msg.sender) {
            revert NotKnoBlockOwner();
        }
        if (myKnoBlock.Unlocked == true) {
            revert KnoBlockUnlocked('KnoBlock is already Unlocked');
        }
        myKnoBlock.Deleted = true;
    }

    function _claim(uint256 blockId) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockId];
        if (myKnoBlock.creator != msg.sender) {
            revert NotKnoBlockOwner();
        }
        if (myKnoBlock.Deleted == true) {
            revert KnoBlockDeleted();
        }
        if (myKnoBlock.Unlocked != true) {
            revert KnoBlockLocked();
        }
        payable(msg.sender).transfer(myKnoBlock.unlockAmount);
        myKnoBlock.Deleted = true;
    }

    //views


    function _getKnoBlock(
        uint256 blockId
    )
        internal
        view
        returns (KnoBlockStorage.KnoBlock storage knoBlock
        )
    {
        knoBlock = KnoBlockStorage.layout().knoBlocks[blockId];
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
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockId];
        return myKnoBlock.creator;
    }

    function _returnKnoBlockUnlockAmount(
        uint256 blockId
    ) internal view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockId];
        return myKnoBlock.unlockAmount;
    }

    function _returnKnoBlockCurrentAmount(
        uint256 blockId
    ) internal view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockId];
        return myKnoBlock.currentAmount;
    }

    function _returnKnoBlockKnoType(
        uint256 blockId
    ) internal view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockId];
        return uint256(myKnoBlock.knoType);
    }

    function _returnKnoBlockUnlocked(
        uint256 blockId
    ) internal view returns (bool) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockId];
        return myKnoBlock.Unlocked;
    }

    function _returnKnoBlockDeleted(
        uint256 blockId
    ) internal view returns (bool) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockId];
        return myKnoBlock.Deleted;
    }

    function _returnKnoBlockDeposits(
        uint256 blockId
    ) internal view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockId];
        return myKnoBlock.deposits[msg.sender];
    }
}
