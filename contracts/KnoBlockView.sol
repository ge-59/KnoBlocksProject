// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { KnoBlockInternal } from './KnoBlockInternal.sol';
import { IKnoBlockInternal } from './IKnoBlockInternal.sol';
import { KnoBlockStorage } from './KnoBlockStorage.sol';
import { KnoBlockAdmin } from './KnoBlockAdmin.sol';
import { IKnoBlockView } from './IKnoBlockView.sol';

contract KnoBlockView is KnoBlockInternal, KnoBlockAdmin, IKnoBlockView {
    function count() external view returns (uint256 num) {
        return _count();
    }

    function owned() external view returns (address owner) {
        return _owned();
    }

    function creator(uint256 blockId) external view returns (address blocker) {
        return _creator(blockId);
    }

    function unlockAmount(
        uint256 blockId
    ) external view returns (uint256 amount) {
        return _unlockAmount(blockId);
    }

    function currentAmount(
        uint256 blockId
    ) external view returns (uint256 amount) {
        return _currentAmount(blockId);
    }

    function knoType(uint256 blockId) external view returns (uint256 format) {
        return _knoType(blockId);
    }

    function cancelled(uint256 blockId) external view returns (bool status) {
        return _cancelled(blockId);
    }

    function deposits(
        uint256 blockId,
        address account
    ) external view returns (uint256 amount) {
        return _deposits(blockId, account);
    }

    function withdrawFees() external view returns (uint256 fee) {
        return _withdrawFees();
    }

    function depositFees() external view returns (uint256 fee) {
        return _depositFees();
    }
}
