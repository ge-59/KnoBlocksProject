// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

interface IKnoBlockAdmin {
    /**
     * @notice sets a new owner
     * @param owner the address of the new owner
     */
    function setOwner(address owner) external;

    /**
     * @notice for admin to set the withdrawFee in BASIS
     * @param feeBP the percentage fee in BASIS points
     */
    function setWithdrawFeeBP(uint256 feeBP) external;

    /**
     * @notice for admin to set the depositFee in BASIS
     * @param feeBP the percentage fee in BASIS points
     */
    function setDepositFeeBP(uint256 feeBP) external;

    /**
     * @notice for admin to withdraw the fees earned
     */
    function withdrawFees() external;
}
