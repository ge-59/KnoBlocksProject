// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { KnoBlockInternal } from './KnoBlockInternal.sol';
import { IKnoBlockInternal } from './IKnoBlockInternal.sol';
import { KnoBlockStorage } from './KnoBlockStorage.sol';

contract KnoBlockView is KnoBlockInternal {
    /* function getKnoBlock(
        uint256 blockId
    ) external view returns (KnoBlockStorage.KnoBlock storage knoBlock) {
        _getKnoBlock(blockId);
    } */

    function count() external view returns (uint256) {
        _count();
    }

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

    function unlocked(uint256 blockId) external view returns (bool) {
        _unlocked(blockId);
    }

    function cancelled(uint256 blockId) external view returns (bool) {
        _cancelled(blockId);
    }

    function deposits(uint256 blockId) external view returns (uint256) {
        _deposits(blockId);
    }
}
