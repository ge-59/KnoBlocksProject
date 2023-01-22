// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

interface IKnoBlockInternal {
    event NewKnoBlock(uint256 blockId);
    // To signal the release of a new IoI.
    event BlockUnlocked(uint256 blockId);

    error KnoBlockUnlocked(string reason); //any reason to have the message
    // some random video said no point to custom if ya dont
    error InvalidWithdraw(string reason, uint256 userDepositAmount);
    error NotKnoBlockOwner();
    error KnoBlockDeleted();
    error KnoBlockLocked();

    // To define the type of information.
    enum KnoType {
        PDF,
        MP4,
        Doc
    }
}
