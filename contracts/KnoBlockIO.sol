// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { KnoBlockInternal } from './KnoBlockInternal.sol';
import { IKnoBlockIO } from './IKnoBlockIO.sol';

contract KnoBlockIO is KnoBlockInternal, IKnoBlockIO {

    /**
     * @inheritdoc IKnoBlockIO
     */

    function create(uint256 unlockValue, KnoType knoType) public override payable {
        _create(unlockValue, knoType);
    }

    function deposit(uint256 blockId) public override payable {
        _deposit(blockId);
    }

    function withdraw(uint256 blockId, uint256 amount) public override {
        _withdraw(blockId, amount);
    }

    function cancel(uint256 blockId) public override {
        _cancel(blockId);
    }

    function claim(uint256 blockId) public override {
        _claim(blockId); 
    }
}
