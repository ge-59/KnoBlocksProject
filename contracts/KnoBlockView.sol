// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { KnoBlockInternal } from './KnoBlockInternal.sol';

contract KnoBlockView is KnoBlockInternal {
    function getKnoBlock(
        uint256 blockId
    )
        external
        view
        returns (
            address creator,
            uint256 unlockAmount,
            uint256 currentAmount,
            KnoType knoType,
            bool unlocked
        )
    {
        (
            creator,
            unlockAmount,
            currentAmount,
            knoType,
            unlocked
        ) = _getKnoBlock(blockId);
    }

    function returnCount() public view {
        _returnCount();
    }

    function returnOwner() public view {
        _returnOwner();
    }

    function returnKnoBlockCreator(uint256 blockId) public view {
        _returnKnoBlockCreator(blockId);
    }

    function returnKnoBlockUnlockAmount(uint256 blockId) public view {
        _returnKnoBlockUnlockAmount(blockId);
    }

    function returnKnoBlockCurrentAmount(uint256 blockId) public view {
        _returnKnoBlockCurrentAmount(blockId);
    }

    function returnKnoBlockKnoType(uint256 blockId) public view {
        _returnKnoBlockKnoType(blockId);
    }

    function returnKnoBlockUnlocked(uint256 blockId) public view {
        _returnKnoBlockUnlocked(blockId);
    }

    function returnKnoBlockDeleted(uint256 blockId) public view {
        _returnKnoBlockDeleted(blockId);
    }

    function returnKnoBlockDeposits(uint256 blockId) public view {
        _returnKnoBlockDeleted(blockId);
    }
}
