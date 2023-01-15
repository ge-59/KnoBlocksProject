// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import { OwnableInternal } from '@solidstate/contracts/access/ownable/OwnableInternal.sol';
import { KnoBlockStorage } from './KnoBlockStorage.sol';
import { IKnoBlockInternal } from './IKnoBlockInternal.sol';

abstract contract KnoBlockInternal is OwnableInternal, IKnoBlockInternal {
    constructor() {
        _setOwner(msg.sender);
    }

    function _createKnoBlock(uint256 unlockValue, KnoType knoType) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        uint256 blockId = l.count;
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockId];
        myKnoBlock.creator = msg.sender;
        myKnoBlock.unlockAmount = unlockValue;
        myKnoBlock.knoType = knoType;
        l.count++;
        emit NewKnoBlock(blockId, msg.sender, unlockValue, 0, knoType);
    }

    function _deposit(uint256 blockid) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockid];
        require(myKnoBlock.Unlocked == false, 'KnoBlock Already Unlocked');
        uint256 previousCurrentAmount = myKnoBlock.currentAmount;
        myKnoBlock.currentAmount += msg.value;
        if (myKnoBlock.currentAmount == myKnoBlock.unlockAmount) {
            // Would it make sense to reverse these if the second "if" is far more likely??? Yes
            myKnoBlock.Unlocked = true;
            emit BlockUnlocked(
                blockid,
                myKnoBlock.creator,
                myKnoBlock.unlockAmount,
                myKnoBlock.currentAmount,
                myKnoBlock.knoType
            );
        } else if (myKnoBlock.currentAmount > myKnoBlock.unlockAmount) {
            myKnoBlock.Unlocked = true;
            payable(msg.sender).transfer(
                myKnoBlock.currentAmount - myKnoBlock.unlockAmount
            );
            myKnoBlock.currentAmount = myKnoBlock.unlockAmount;
            emit BlockUnlocked(
                blockid,
                myKnoBlock.creator,
                myKnoBlock.unlockAmount,
                myKnoBlock.currentAmount,
                myKnoBlock.knoType
            );
        }
        myKnoBlock.deposits[msg.sender] += (myKnoBlock.currentAmount -
            previousCurrentAmount);
    }

    function _withdraw(uint256 blockid, uint256 amount) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockid];
        // make above into seperate function?? wont we need in ALL functions the myKnoblock
        require(myKnoBlock.Unlocked == false, 'KnoBlock Already Unlocked');
        require(
            myKnoBlock.deposits[msg.sender] >= amount,
            'Invalid Amount/Invalid Caller'
        );
        myKnoBlock.currentAmount -= amount;
        myKnoBlock.deposits[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
}
