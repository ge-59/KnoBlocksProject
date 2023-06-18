// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

interface IKnoBlockAdmin {
    function setOwner(address owner) external;

    function setWithdrawFee(uint256 fee) external;

    function setDepositFee(uint256 fee) external;

    function withdrawBalance() external;
}
