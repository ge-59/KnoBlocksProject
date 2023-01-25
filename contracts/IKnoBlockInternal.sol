// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

interface IKnoBlockInternal {
    event NewKnoBlock(uint256 blockId);
    event BlockUnlocked(uint256 blockId);

    error KnoBlockUnlocked();
    error InvalidWithdraw();
    error NotKnoBlockOwner();
    error KnoBlockCancelled();
    error KnoBlockLocked();

    enum KnoType {
        PDF,
        MP4,
        Doc
    }
}
