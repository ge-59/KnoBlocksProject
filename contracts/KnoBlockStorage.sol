// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

import { IKnoBlockInternal } from './IKnoBlockInternal.sol';

library KnoBlockStorage {
    struct Layout {
        address owner;
        uint256 count;
        //struct mappings:
        mapping(uint256 => address) creator;
        mapping(uint256 => uint256) unlockAmount;
        mapping(uint256 => uint256) currentAmount;
        mapping(uint256 => IKnoBlockInternal.KnoType) knoType;
        mapping(uint256 => bool) unlocked;
        mapping(address => uint256) deposits; //currently has massive flaw
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
