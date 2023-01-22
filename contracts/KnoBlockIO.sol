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

    function knoDeposit(uint256 blockId) public payable {
        _deposit(blockId);
    }

    function knoWithdraw(uint256 blockId, uint256 amount) public {
        _withdraw(blockId, amount);
    }

    function knoDelete(uint256 blockId) public {
        _delete(blockId);
    }

    function knoClaim(uint256 blockId) public {
        _claim(blockId);
    }
}
