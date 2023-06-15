// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { Ownable } from '@solidstate/contracts/access/ownable/Ownable.sol';
import { OwnableStorage } from '@solidstate/contracts/access/ownable/OwnableStorage.sol';
import { AddressUtils } from '@solidstate/contracts/utils/AddressUtils.sol';
import { KnoBlockStorage } from './KnoBlockStorage.sol';
import { IKnoBlockAdmin } from './IKnoBlockAdmin.sol';
import { KnoBlockInternal } from './KnoBlockInternal.sol';

contract KnoBlockAdmin is IKnoBlockAdmin, KnoBlockInternal {
    using AddressUtils for address payable;

    function settOwner(address owner) external onlyOwner {
        _setOwner(owner);
    }

    function setWithdrawFee(uint256 fee) external onlyOwner {
        _setWithdrawFee(fee);
    }

    function setDepositFee(uint256 fee) external onlyOwner {
        _setDepositFee(fee);
    }

    function withdrawBalance(uint256 amount) external onlyOwner {
        _withdrawBalance(amount);
    }
}
