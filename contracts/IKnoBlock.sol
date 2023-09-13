// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { IKnoBlockInternal } from './IKnoBlockInternal.sol';
import { IKnoBlockIO } from './IKnoBlockIO.sol';
import { IKnoBlockAdmin } from './IKnoBlockAdmin.sol';
import { IKnoBlockView } from './IKnoBlockView.sol';
import { IOwnable } from '@solidstate/contracts/access/ownable/IOwnable.sol';

/**
 * @title complete KnoBlock interface
 * @notice this interface aggregates the various interfaces that make up the KnoBlock functionality
 */

interface IKnoBlock is
    IKnoBlockInternal,
    IKnoBlockIO,
    IKnoBlockAdmin,
    IKnoBlockView,
    IOwnable
{

}
