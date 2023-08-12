// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

interface IKnoBlockAdmin {
    function setOwner(address owner) external;

    function setWithdrawFeeBP(uint256 fee) external;

    function setDepositFeeBP(uint256 fee) external;

    function withdrawFees() external;
}
