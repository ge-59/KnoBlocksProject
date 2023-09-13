// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { KnoBlockInternal } from './KnoBlockInternal.sol';
import { IKnoBlockInternal } from './IKnoBlockInternal.sol';
import { KnoBlockStorage } from './KnoBlockStorage.sol';
import { IKnoBlockView } from './IKnoBlockView.sol';

/**
 * @title KnoBlockView Contract
 * @notice diamond facet implementing the read-only functions to retrieve information about the current state of the KnoBlock Dapp
 */
contract KnoBlockView is KnoBlockInternal, IKnoBlockView {
    /**
     * @inheritdoc IKnoBlockView
     */
    function count() external view returns (uint256 num) {
        num = _count();
    }

    /**
     * @inheritdoc IKnoBlockView
     */
    function creator(uint256 blockId) external view returns (address blocker) {
        blocker = _creator(blockId);
    }

    /**
     * @inheritdoc IKnoBlockView
     */
    function unlockAmount(
        uint256 blockId
    ) external view returns (uint256 amount) {
        amount = _unlockAmount(blockId);
    }

    /**
     * @inheritdoc IKnoBlockView
     */
    function currentAmount(
        uint256 blockId
    ) external view returns (uint256 amount) {
        amount = _currentAmount(blockId);
    }

    /**
     * @inheritdoc IKnoBlockView
     */
    function knoType(uint256 blockId) external view returns (uint256 format) {
        format = _knoType(blockId);
    }

    /**
     * @inheritdoc IKnoBlockView
     */
    function cancelled(uint256 blockId) external view returns (bool status) {
        status = _cancelled(blockId);
    }

    /**
     * @inheritdoc IKnoBlockView
     */
    function deposits(
        uint256 blockId,
        address account
    ) external view returns (uint256 amount) {
        amount = _deposits(blockId, account);
    }

    /**
     * @inheritdoc IKnoBlockView
     */
    function withdrawFeeBP() external view returns (uint256 feeBP) {
        feeBP = _withdrawFeeBP();
    }

    /**
     * @inheritdoc IKnoBlockView
     */
    function depositFeeBP() external view returns (uint256 feeBP) {
        feeBP = _depositFeeBP();
    }

    /**
     * @inheritdoc IKnoBlockView
     */
    function feesCollected() external view returns (uint256 total) {
        total = _feesCollected();
    }
}
