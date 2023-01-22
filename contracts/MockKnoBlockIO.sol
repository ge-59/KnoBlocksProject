// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { KnoBlockIO } from './KnoBlockIO.sol';
import { KnoBlockStorage } from './KnoBlockStorage.sol';
import { OwnableStorage } from '@solidstate/contracts/access/ownable/OwnableStorage.sol';

contract MockKnoBlockIO is KnoBlockIO {
    function MockReturnCount() public view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return l.count;
    }

    function MockReturnOwner() public view returns (address) {
        OwnableStorage.Layout storage l = OwnableStorage.layout();
        return l.owner;
    }

    function MockReturnKnoBlockCreator(
        uint256 blockId
    ) public view returns (address) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return l.creator[blockId];
    }

    function MockReturnKnoBlockUnlockAmount(
        uint256 blockId
    ) public view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return l.unlockAmount[blockId];
    }

    function MockReturnKnoBlockCurrentAmount(
        uint256 blockId
    ) public view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return l.currentAmount[blockId];
    }

    function MockReturnKnoBlockKnoType(
        uint256 blockId
    ) public view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return uint256(l.knoType[blockId]);
    }

    function MockReturnKnoBlockUnlocked(
        uint256 blockId
    ) public view returns (bool) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return l.unlocked[blockId];
    }

    function MockReturnKnoBlockDeleted(
        uint256 blockId
    ) public view returns (bool) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return l.deleted[blockId];
    }

    function MockReturnKnoBlockDeposits(
        uint256 blockId
    ) public view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return l.deposits[blockId][msg.sender];
    }

    function MockReturnKnoBlockBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
