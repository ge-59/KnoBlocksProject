import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { IKnoBlock } from '../typechain-types';
import {
  KnoBlockIOBehaviorArgs,
  describeBehaviorOfKnoBlockIO,
} from '../test/KnoBlockIO';
import {
  KnoBlockAdminBehaviorArgs,
  describeBehaviorOfKnoBlockAdmin,
} from '../test/KnoBlockAdmin';
import {
  KnoBlockViewBehaviorArgs,
  describeBehaviorOfKnoBlockView,
} from '../test/KnoBlockView';

export interface KnoBlockProxyBehaviorArgs
  extends KnoBlockIOBehaviorArgs,
    KnoBlockAdminBehaviorArgs,
    KnoBlockViewBehaviorArgs {}

export function describeBehaviorOfKnoBlockProxy(
  deploy: () => Promise<IKnoBlock>,
) {
  describe('::KnoBlockProxy', () => {
    describeBehaviorOfKnoBlockIO(deploy);
    describeBehaviorOfKnoBlockAdmin(deploy);
    describeBehaviorOfKnoBlockView(deploy);
  });
}
