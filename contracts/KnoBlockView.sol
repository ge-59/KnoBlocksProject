// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { KnoBlockInternal } from './KnoBlockInternal.sol';
import { IKnoBlockInternal } from './IKnoBlockInternal.sol';
import { KnoBlockStorage } from './KnoBlockStorage.sol';

contract KnoBlockView is KnoBlockInternal {
   
    function count() external view returns (uint256) {
       return _count();
    } //////////

    function owned() external view returns (address) {
        _owned();
    }

    function creator(uint256 blockId) external view returns (address) {
        _creator(blockId);
    }

    function unlockAmount(uint256 blockId) external view returns (uint256) {
        _unlockAmount(blockId);
    }

    function currentAmount(uint256 blockId) external view returns (uint256) {
        _currentAmount(blockId);
    }

    function knoType(
        uint256 blockId
    ) external view returns (IKnoBlockInternal.KnoType) {
        _knoType(blockId);
    }

    function cancelled(uint256 blockId) external view returns (bool status) {
        _cancelled(blockId);
    }

    function deposits(uint256 blockId) external view returns (uint256 amount) {
        _deposits(blockId);
    }
}
