// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { SolidStateDiamond } from '@solidstate/contracts/proxy/diamond/SolidStateDiamond.sol';
import { KnoBlockStorage } from './KnoBlockStorage.sol';

contract KnoBlockDiamond is SolidStateDiamond {

    constructor(uint256 withdrawToll, uint256 depositToll) {
      KnoBlockStorage.Layout storage l = KnoBlockStorage.layout();
      l.withdrawFee = withdrawToll; 
      l.depositFee = depositToll;
    }
    
}
