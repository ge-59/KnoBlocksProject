// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { OwnableStorage } from '@solidstate/contracts/access/ownable/OwnableStorage.sol';
import { KnoBlockStorage } from './KnoBlockStorage.sol';
import { IKnoBlockAdmin } from './IKnoBlockAdmin.sol';
import { KnoBlockInternal } from './KnoBlockInternal.sol';

/**
 * @title KnoBlockAdmin Contract
 * @notice diamond facet implementing administrative functions for managing the KnoBlock Dapp
 */

contract KnoBlockAdmin is IKnoBlockAdmin, KnoBlockInternal {
    /**
     * @inheritdoc IKnoBlockAdmin
     */
    function setOwner(address owner) external onlyOwner {
        _setOwner(owner);
    }

    /**
     * @inheritdoc IKnoBlockAdmin
     */
    function setWithdrawFeeBP(uint256 feeBP) external onlyOwner {
        _setWithdrawFeeBP(feeBP);
    }

    /**
     * @inheritdoc IKnoBlockAdmin
     */
    function setDepositFeeBP(uint256 feeBP) external onlyOwner {
        _setDepositFeeBP(feeBP);
    }

    /**
     * @inheritdoc IKnoBlockAdmin
     */
    function withdrawFees() external onlyOwner {
        _withdrawFees();
    }
}
