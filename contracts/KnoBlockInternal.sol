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

    function _getBlock(
        uint256 blockId
    ) internal view returns (KnoBlockStorage.KnoBlock storage knoBlock) {
        knoBlock = KnoBlockStorage.layout().knoBlocks[MAPPING_SLOT][blockId];
    }

    function _create(uint256 unlockValue, KnoType knoType) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        uint256 blockId = l.count;
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[MAPPING_SLOT][
            blockId
        ];
        myKnoBlock.creator = msg.sender;
        myKnoBlock.unlockAmount = unlockValue;
        myKnoBlock.currentAmount = 0;
        myKnoBlock.knoType = knoType;
        ++l.count;
        emit NewKnoBlock(blockId);
    }

    function _deposit(uint256 blockId) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[MAPPING_SLOT][
            blockId
        ];
        if (myKnoBlock.Unlocked == true) {
            revert KnoBlockUnlocked();
        }
        if (myKnoBlock.Cancelled == true) {
            revert KnoBlockCancelled();
        }
        uint256 blockAmount = myKnoBlock.currentAmount;
        uint256 blockValue = myKnoBlock.unlockAmount;
        blockAmount += msg.value;
        myKnoBlock.deposits[msg.sender] += msg.value;
        myKnoBlock.currentAmount = blockAmount;
        if (blockAmount >= blockValue) {
            myKnoBlock.Unlocked = true;
            emit BlockUnlocked(blockId);
        }
        if (blockAmount > blockValue) {
            payable(msg.sender).transfer(blockAmount - blockValue);
            myKnoBlock.currentAmount = blockValue;
        }
    }
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
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[MAPPING_SLOT][
            blockId
        ];
        if (myKnoBlock.Unlocked == true) {
            revert KnoBlockUnlocked();
        }
        if (myKnoBlock.deposits[msg.sender] < amount) {
            revert InvalidWithdraw();
        } 
                myKnoBlock.currentAmount -= amount;
        myKnoBlock.deposits[msg.sender] -= amount;
        payable(msg.sender).sendValue(amount);
    }

    function _cancel(uint256 blockId) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[MAPPING_SLOT][
            blockId
        ];
        if (myKnoBlock.creator != msg.sender) {
            revert NotKnoBlockOwner();
        }
        if (myKnoBlock.Unlocked == true) {
            revert KnoBlockUnlocked();
        }
        myKnoBlock.Cancelled = true;
    }

    function _claim(uint256 blockId) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[MAPPING_SLOT][
            blockId
        ];
        if (myKnoBlock.creator != msg.sender) {
            revert NotKnoBlockOwner();
        }
        if (myKnoBlock.Cancelled == true) {
            revert KnoBlockCancelled();
        }
        if (myKnoBlock.Unlocked != true) {
            revert KnoBlockLocked();
        }
        payable(msg.sender).transfer(myKnoBlock.unlockAmount);
        myKnoBlock.Cancelled = true;
    }

    //views

    function _getKnoBlock(
        uint256 blockId
    ) internal view returns (KnoBlockStorage.KnoBlock storage knoBlock) {
        knoBlock = KnoBlockStorage.layout().knoBlocks[MAPPING_SLOT][blockId];
    }

    function _count() internal view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return l.count;
    }

    function _owned() internal view returns (address) {
        OwnableStorage.Layout storage l = OwnableStorage.layout();
        return l.owner;
    }

    function _creator(uint256 blockId) internal view returns (address) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[MAPPING_SLOT][
            blockId
        ];
        return myKnoBlock.creator;
    }

    function _unlockAmount(uint256 blockId) internal view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[MAPPING_SLOT][
            blockId
        ];
        return myKnoBlock.unlockAmount;
    }

    function _currentAmount(uint256 blockId) internal view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[MAPPING_SLOT][
            blockId
        ];
        return myKnoBlock.currentAmount;
    }

    function _knoType(uint256 blockId) internal view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[MAPPING_SLOT][
            blockId
        ];
        return uint256(myKnoBlock.knoType);
    }

    function _unlocked(uint256 blockId) internal view returns (bool) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[MAPPING_SLOT][
            blockId
        ];
        return myKnoBlock.Unlocked;
    }

    function _cancelled(uint256 blockId) internal view returns (bool) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[MAPPING_SLOT][
            blockId
        ];
        return myKnoBlock.Cancelled;
    }

    function _deposits(uint256 blockId) internal view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[MAPPING_SLOT][
            blockId
        ];
        return myKnoBlock.deposits[msg.sender];
    }
}
