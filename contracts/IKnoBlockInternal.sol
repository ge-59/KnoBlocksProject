// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

interface IKnoBlockInternal {
    event KnoBlockCreated(uint256 blockId);
    event BlockUnlocked(uint256 blockId);

    error KnoBlockUnlocked();
    error InvalidAmount();
    error NotKnoBlockOwner();
    error KnoBlockisCancelled();
    error KnoBlockLocked();
    error FeeOver100();

    enum KnoType {
        PDF,
        MP4,
        Doc
    }
}
