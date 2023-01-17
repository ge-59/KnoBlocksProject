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
        uint256 blockid = l.count;
        l.creator[blockid] = msg.sender;
        l.unlockAmount[blockid] = unlockValue;
        l.currentAmount[blockid] = 0;
        l.knoType[blockid] = knoType;
        l.unlocked[blockid] = false;
        l.count++;
        emit NewKnoBlock(blockid, msg.sender, unlockValue, 0, knoType);
    }

    function _deposit(uint256 blockid) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        require(l.unlocked[blockid] == false, 'KnoBlock Already Unlocked');
        uint256 previousCurrentAmount = l.currentAmount[blockid];
        l.currentAmount[blockid] += msg.value;
        if (l.currentAmount[blockid] == l.unlockAmount[blockid]) {
            // Would it make sense to reverse these if the second "if" is far more likely??? Yes
            l.unlocked[blockid] = true;
            emit BlockUnlocked(
                blockid,
                l.creator[blockid],
                l.unlockAmount[blockid],
                l.currentAmount[blockid],
                l.knoType[blockid]
            );
        } else if (l.currentAmount[blockid] > l.unlockAmount[blockid]) {
            l.unlocked[blockid] = true;
            payable(msg.sender).transfer(
                l.currentAmount[blockid] - l.unlockAmount[blockid]
            );
            l.currentAmount[blockid] = l.unlockAmount[blockid];
            emit BlockUnlocked(
                blockid,
                l.creator[blockid],
                l.unlockAmount[blockid],
                l.currentAmount[blockid],
                l.knoType[blockid]
            );
        }
        l.deposits[msg.sender] += (l.currentAmount[blockid] -
            previousCurrentAmount);
    }

    function _withdraw(uint256 blockid, uint256 amount) internal {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        // make above into seperate function?? wont we need in ALL functions the fuck w the Knoblock
        require(l.unlocked[blockid] == false, 'KnoBlock Already Unlocked');
        require(
            l.deposits[msg.sender] >= amount,
            'Invalid Amount/Invalid Caller'
        );
        l.currentAmount[blockid] -= amount;
        l.deposits[msg.sender] -= amount;
        payable(msg.sender).transfer(amount);
    }
}
