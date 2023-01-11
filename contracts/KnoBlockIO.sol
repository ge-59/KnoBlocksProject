// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { KnoBlockInternal } from './KnoBlockInternal.sol';

contract KnoBlockIO is KnoBlockInternal {
    function createKnoBlock(
        uint256 unlockValue,
        KnoType knoType
    ) public payable {
        _createKnoBlock(unlockValue, knoType);
    }

    function knoDeposit(uint256 blockid) public payable {
        _deposit(blockid);
    }

    function knoWithdraw(uint256 blockid, uint256 amount) public {
        _withdraw(blockid, amount);
    }
}
