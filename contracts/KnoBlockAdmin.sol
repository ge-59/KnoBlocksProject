// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { OwnableStorage } from '@solidstate/contracts/access/ownable/OwnableStorage.sol';
import { KnoBlockStorage } from './KnoBlockStorage.sol';
import { IKnoBlockAdmin } from './IKnoBlockAdmin.sol';
import { KnoBlockInternal } from './KnoBlockInternal.sol';

contract KnoBlockAdmin is IKnoBlockAdmin, KnoBlockInternal {
    function setOwner(address owner) external onlyOwner {
        _setOwner(owner);
    }

    function setWithdrawFeeBP(uint256 feeBP) external onlyOwner {
        _setWithdrawFeeBP(feeBP);
    }

    function setDepositFeeBP(uint256 feeBP) external onlyOwner {
        _setDepositFeeBP(feeBP);
    }

    function withdrawFees() external onlyOwner {
        _withdrawFees();
    }
}
