// SPDX-License-Identifier: MIT

pragma solidity ^0.8.8;

/**
 * @title KnoBlockView Interface
 * @notice this interface provides the read-only functions to retrieve information about the current state of the KnoBlock Dapp
 */
interface IKnoBlockView {
    /**
     * @notice returns the variable: Count, used to set KnoBlock ID's
     */
    function count() external view returns (uint256 num);

    /**
     * @notice returns a KnoBlock's Creator address
     * @param blockId the identifier for a KnoBlock Struct
     */
    function creator(uint256 blockId) external view returns (address blocker);

    /**
     * @notice returns the total amount of ETH required for a KnoBlock to unlock
     * @param blockId the identifier for a KnoBlock Struct
     */
    function unlockAmount(
        uint256 blockId
    ) external view returns (uint256 amount);

    /**
     * @notice returns the current amount deposited within a KnoBlock
     * @param blockId the identifier for a KnoBlock Struct
     */
    function currentAmount(
        uint256 blockId
    ) external view returns (uint256 amount);

    /**
     * @notice returns the type of information a KnoBlock holds
     * @param blockId the identifier for a KnoBlock Struct
     */
    function knoType(uint256 blockId) external view returns (uint256 format);

    /**
     * @notice returns whether a KnoBlock has been closed (cancelled or completed)
     * @param blockId the identifier for a KnoBlock Struct
     */
    function cancelled(uint256 blockId) external view returns (bool status);

    /**
     * @notice returns the amount msg.sender has deposited in a KnoBlock
     * @param blockId the identifier for a KnoBlock Struct
     */
    function deposits(
        uint256 blockId,
        address account
    ) external view returns (uint256 amount);

    /**
     * @notice returns the current withdrawFee in BASIS
     */
    function withdrawFeeBP() external view returns (uint256 feeBP);

    /**
     * @notice returns the current depositFee in BASIS
     */
    function depositFeeBP() external view returns (uint256 feeBP);

    /**
     * @notice returns the current amount of ETH accumulated from fees
     */
    function feesCollected() external view returns (uint256 total);
}
