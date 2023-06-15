// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { KnoBlockInternal } from './KnoBlockInternal.sol';
import { IKnoBlockIO } from './IKnoBlockIO.sol';

contract KnoBlockIO is KnoBlockInternal, IKnoBlockIO {
    /**
     * @inheritdoc IKnoBlockIO
     */
    function create(uint256 unlockAmount, KnoType knoType) external payable {
        _create(unlockAmount, knoType);
    }

    /**
     * @inheritdoc IKnoBlockIO
     */
    function deposit(uint256 blockId, uint256 amount) external payable {
        _deposit(blockId, amount);
    }

    /**
     * @inheritdoc IKnoBlockIO
     */
    function withdraw(uint256 blockId, uint256 amount) external {
        _withdraw(blockId, amount);
    }

    /**
     * @inheritdoc IKnoBlockIO
     */
    function cancel(uint256 blockId) external {
        _cancel(blockId);
    }

    /**
     * @inheritdoc IKnoBlockIO
     */
    function claim(uint256 blockId) external {
        _claim(blockId);
    }
}
