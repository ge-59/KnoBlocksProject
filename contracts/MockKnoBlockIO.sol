// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { KnoBlockIO } from './KnoBlockIO.sol';
import { KnoBlockView } from './KnoBlockView.sol';
import { KnoBlockStorage } from './KnoBlockStorage.sol';
import { OwnableStorage } from '@solidstate/contracts/access/ownable/OwnableStorage.sol';

contract MockKnoBlockIO is KnoBlockIO, KnoBlockView {
    function MockCount() public view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        return l.count;
    }

    function MockOwner() public view returns (address) {
        OwnableStorage.Layout storage l = OwnableStorage.layout();
        return l.owner;
    }

    function MockCreator(uint256 blockId) public view returns (address) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[MAPPING_SLOT][
            blockId
        ];
        return myKnoBlock.creator;
    }

    function MockUnlockAmount(uint256 blockId) public view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[MAPPING_SLOT][
            blockId
        ];
        return myKnoBlock.unlockAmount;
    }

    function MockCurrentAmount(uint256 blockId) public view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[MAPPING_SLOT][
            blockId
        ];
        return myKnoBlock.currentAmount;
    }

    function MockType(uint256 blockId) public view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[MAPPING_SLOT][
            blockId
        ];
        return uint256(myKnoBlock.knoType);
    }

    function MockCancelled(uint256 blockId) public view returns (bool) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[MAPPING_SLOT][
            blockId
        ];
        return myKnoBlock.isCancelled;
    }

    function MockDeposits(uint256 blockId) public view returns (uint256) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        KnoBlockStorage.KnoBlock storage myKnoBlock = l.knoBlocks[MAPPING_SLOT][
            blockId
        ];
        return myKnoBlock.deposits[msg.sender];
    }

    function MockBalance() public view returns (uint256) {
        return address(this).balance;
    }
}
