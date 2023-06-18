// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { KnoBlockInternal } from './KnoBlockInternal.sol';
import { IKnoBlockInternal } from './IKnoBlockInternal.sol';
import { KnoBlockStorage } from './KnoBlockStorage.sol';
import { IKnoBlockView } from './IKnoBlockView.sol';

contract KnoBlockView is KnoBlockInternal, IKnoBlockView {
    function count() external view returns (uint256 num) {
        num = _count();
    }

    function creator(uint256 blockId) external view returns (address blocker) {
        blocker = _creator(blockId);
    }

    function unlockAmount(
        uint256 blockId
    ) external view returns (uint256 amount) {
        amount = _unlockAmount(blockId);
    }

    function currentAmount(
        uint256 blockId
    ) external view returns (uint256 amount) {
        amount = _currentAmount(blockId);
    }

    function knoType(uint256 blockId) external view returns (uint256 format) {
        format = _knoType(blockId);
    }

    function cancelled(uint256 blockId) external view returns (bool status) {
        status = _cancelled(blockId);
    }

    function deposits(
        uint256 blockId,
        address account
    ) external view returns (uint256 amount) {
        amount = _deposits(blockId, account);
    }

    function withdrawFees() external view returns (uint256 fee) {
        fee = _withdrawFees();
    }

    function depositFees() external view returns (uint256 fee) {
        fee = _depositFees();
    }

    function feesCollected() external view returns (uint256 total) {
        total = _feesCollected();
    }
}
