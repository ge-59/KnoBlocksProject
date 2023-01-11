// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

interface IKnoBlockInternal {
    event NewKnoBlock(
        uint256 blockId,
        address creator,
        uint256 unlockAmount,
        uint256 currentAmount,
        KnoType knoType
    );
    // To signal the release of a new IoI.
    event BlockUnlocked(
        uint256 blockId,
        address creator,
        uint256 unlockAmount,
        uint256 currentAmount,
        KnoType knoType
    );

    // To define the type of information.
    enum KnoType {
        PDF,
        MP4,
        Doc
    }
}
