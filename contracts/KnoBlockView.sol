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

    function Count() external view {
        _Count();
    }

    function Owner() external view {
        _Owner();
    }

    function Creator(uint256 blockId) external view {
        _Creator(blockId);
    }

    function UnlockAmount(uint256 blockId) external view {
        _UnlockAmount(blockId);
    }

    function CurrentAmount(uint256 blockId) external view {
        _CurrentAmount(blockId);
    }

    function Type(uint256 blockId) external view {
        _Type(blockId);
    }

    function Unlocked(uint256 blockId) external view {
        _Unlocked(blockId);
    }

    function Deleted(uint256 blockId) external view {
        _Deleted(blockId);
    }

    function Deposits(uint256 blockId) external view {
        _Deleted(blockId);
    }
}
