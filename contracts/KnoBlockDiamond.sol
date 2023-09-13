// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { SolidStateDiamond } from '@solidstate/contracts/proxy/diamond/SolidStateDiamond.sol';
import { KnoBlockStorage } from './KnoBlockStorage.sol';

/**
 * @title diamond proxy used as centrally controlled KnoBlock implementation
 */
contract KnoBlockDiamond is SolidStateDiamond {
    constructor(uint256 withdrawFeeBP, uint256 depositFeeBP) {
        KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
        l.withdrawFeeBP = withdrawFeeBP;
        l.depositFeeBP = depositFeeBP;
    }
}
