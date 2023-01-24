// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { KnoBlockInternal } from './KnoBlockInternal.sol';
import { IKnoBlockInternal } from './IKnoBlockInternal.sol';

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
            bool unlocked,
            bool deleted
        )
    {
        (
            creator,
            unlockAmount,
            currentAmount,
            knoType,
            unlocked,
            deleted
        ) = _getKnoBlock(blockId);
    }

    function Count() external view returns (uint256) {
        _Count();
    }

    function Owner() external view returns (address) {
        _Owner();
    }

    function Creator(uint256 blockId) external view returns (address) {
        _Creator(blockId);
    }

    function UnlockAmount(uint256 blockId) external view returns (uint256) {
        _UnlockAmount(blockId);
    }

    function CurrentAmount(uint256 blockId) external view returns (uint256) {
        _CurrentAmount(blockId);
    }

    function Type(uint256 blockId) external view returns (IKnoBlockInternal.KnoType) {
        _Type(blockId);
    }

    function Unlocked(uint256 blockId) external view returns (bool) {
        _Unlocked(blockId);
    }

    function Deleted(uint256 blockId) external view returns (bool) {
        _Deleted(blockId);
    }

    function Deposits(uint256 blockId) external view returns (uint256) {
        _Deposits(blockId);
    }
}
