// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import { IKnoBlockInternal } from './IKnoBlockInternal.sol';

library KnoBlockStorage {
    struct KnoBlock {
        address creator;
        uint256 unlockAmount;
        uint256 currentAmount;
        IKnoBlockInternal.KnoType knoType;
        bool Unlocked;
        bool Deleted;
        mapping(address => uint256) deposits;
    }

    struct Layout {
        uint256 count;
        mapping(uint256 => KnoBlock) knoBlocks;
    }

    bytes32 internal constant STORAGE_SLOT =
        keccak256('projects.contracts.storage.knoblocks');

    function layout() internal pure returns (Layout storage l) {
        bytes32 slot = STORAGE_SLOT;
        assembly {
            l.slot := slot
        }
    }
}
