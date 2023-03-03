// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { KnoBlockInternal } from './KnoBlockInternal.sol';
import { IKnoBlockIO } from './IKnoBlockIO.sol';

contract KnoBlockIO is KnoBlockInternal, IKnoBlockIO {
    /**
     * @inheritdoc IKnoBlockIO
     */

    function create(
        uint256 unlockAmount,
        KnoType knoType
    ) external payable override {
        _create(unlockAmount, knoType);
    }

    function deposit(uint256 blockId) external payable override {
        _deposit(blockId);
    }

    function withdraw(uint256 blockId, uint256 amount) external override {
        _withdraw(blockId, amount);
    }

    function cancel(uint256 blockId) external override {
        _cancel(blockId);
    }

    function claim(uint256 blockId) external override {
        _claim(blockId);
    }
}
