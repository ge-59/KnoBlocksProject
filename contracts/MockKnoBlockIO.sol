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
        uint256 blockid
    ) public view returns (address) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockid];
        return myKnoBlock.creator;
    }

    function MockReturnKnoBlockUnlockAmount(
        uint256 blockid
    ) public view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockid];
        return myKnoBlock.unlockAmount;
    }

    function MockReturnKnoBlockCurrentAmount(
        uint256 blockid
    ) public view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockid];
        return myKnoBlock.currentAmount;
    }

    function MockReturnKnoBlockKnoType(
        uint256 blockid
    ) public view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockid];
        return uint256(myKnoBlock.knoType);
    }

    function MockReturnKnoBlockUnlocked(
        uint256 blockid
    ) public view returns (bool) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockid];
        return myKnoBlock.Unlocked;
    }

    function MockReturnKnoBlockDeposits(
        uint256 blockid
    ) public view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[blockid];
        return myKnoBlock.deposits[msg.sender];
    }
}
