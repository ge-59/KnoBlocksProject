// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { OwnableInternal } from '@solidstate/contracts/access/ownable/OwnableInternal.sol';
import { OwnableStorage } from '@solidstate/contracts/access/ownable/OwnableStorage.sol';
import { AddressUtils } from '@solidstate/contracts/utils/AddressUtils.sol';
import { KnoBlockStorage } from './KnoBlockStorage.sol';

contract KnoBlockAdmin is OwnableInternal {
    using AddressUtils for address payable;

    function ownerSet(address owner) public onlyOwner {
        OwnableStorage.Layout storage l = OwnableStorage.layout();
        l.owner = owner;
    }

    function setWithdrawFee(uint256 fee) public onlyOwner {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        l.withdrawFee = fee;
    }

    function setDepositFee(uint256 fee) public onlyOwner {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        l.depositFee = fee;
    }

    function withdrawBalance(uint256 amount) public onlyOwner {
        payable(msg.sender).sendValue(amount);
    }

    // view functions
    function _withdrawFees() internal view returns (uint256 fee) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return l.withdrawFee;
    }

    function _depositFees() internal view returns (uint256 fee) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return l.depositFee;
    }
}
