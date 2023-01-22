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
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockId];
        return myKnoBlock.creator;
    }

    function MockReturnKnoBlockUnlockAmount(
        uint256 blockId
    ) public view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockId];
        return myKnoBlock.unlockAmount;
    }

    function MockReturnKnoBlockCurrentAmount(
        uint256 blockId
    ) public view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockId];
        return myKnoBlock.currentAmount;
    }

    function MockReturnKnoBlockKnoType(
        uint256 blockId
    ) public view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockId];
        return uint256(myKnoBlock.knoType);
    }

    function MockReturnKnoBlockUnlocked(
        uint256 blockId
    ) public view returns (bool) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockId];
        return myKnoBlock.Unlocked;
    }

    function MockReturnKnoBlockDeleted(
        uint256 blockId
    ) public view returns (bool) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockId];
        return myKnoBlock.Deleted;
    }

    function MockReturnKnoBlockDeposits(
        uint256 blockId
    ) public view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockId];
        return myKnoBlock.deposits[msg.sender];
    }

    function MockReturnKnoBlockBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
