// SPDX-License-Identifier: SEE LICENSE IN LICENSE

pragma solidity ^0.8.8;

import { IKnoBlockInternal } from './IKnoBlockInternal.sol';
import { IKnoBlockIO } from './IKnoBlockIO.sol';
import { IKnoBlockAdmin } from './IKnoBlockAdmin.sol';
import { IKnoBlockView } from './IKnoBlockView.sol';

interface IKnoBlock is
    IKnoBlockInternal,
    IKnoBlockIO,
    IKnoBlockAdmin,
    IKnoBlockView
{}
