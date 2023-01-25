// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { KnoBlockInternal } from './KnoBlockInternal.sol';

contract KnoBlockIO is KnoBlockInternal {
    function create(uint256 unlockValue, KnoType knoType) public payable {
        _create(unlockValue, knoType);
    }

    function deposit(uint256 blockId) public payable {
        _deposit(blockId);
    }

    function withdraw(uint256 blockId, uint256 amount) public {
        _withdraw(blockId, amount);
    }

    function cancel(uint256 blockId) public {
        _cancel(blockId);
    }

    function claim(uint256 blockId) public {
        _claim(blockId);
    }
}
