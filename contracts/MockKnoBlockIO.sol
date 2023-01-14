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
        return l.creator[blockid];
    }

    function MockReturnKnoBlockUnlockAmount(
        uint256 blockid
    ) public view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return l.unlockAmount[blockid];
    }

    function MockReturnKnoBlockCurrentAmount(
        uint256 blockid
    ) public view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return l.currentAmount[blockid];
    }

    function MockReturnKnoBlockKnoType(
        uint256 blockid
    ) public view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return uint256(l.knoType[blockid]);
    }

    function MockReturnKnoBlockUnlocked(
        uint256 blockid
    ) public view returns (bool) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return l.unlocked[blockid];
    }

    function MockReturnKnoBlockDeposits() public view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return l.deposits[msg.sender];
    }
}
