// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

interface IKnoBlockView {
    function count() external view returns (uint256 num);

    function owned() external view returns (address owner);

    function creator(uint256 blockId) external view returns (address blocker);

    function unlockAmount(
        uint256 blockId
    ) external view returns (uint256 amount);

    function currentAmount(
        uint256 blockId
    ) external view returns (uint256 amount);

    function knoType(uint256 blockId) external view returns (uint256 format);

    function cancelled(uint256 blockId) external view returns (bool status);

    function deposits(
        uint256 blockId,
        address account
    ) external view returns (uint256 amount);

    function withdrawFees() external view returns (uint256 fee);

    function depositFees() external view returns (uint256 fee);

    function feesCollected() external view returns (uint256 total);
}
