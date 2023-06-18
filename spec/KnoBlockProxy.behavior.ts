import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { IKnoBlock } from '../typechain-types';
import {
  KnoBlockIOBehaviorArgs,
  describeBehaviorOfKnoBlockIO,
} from '../test/KnoBlockIO';

export interface KnoBlockProxyBehaviorArgs extends KnoBlockIOBehaviorArgs {}

export function describeBehaviorOfKnoBlockProxy(
  deploy: () => Promise<IKnoBlock>,
) {
  describe('::KnoBlockProxy', () => {
    describeBehaviorOfKnoBlockIO(deploy);
    // describeBehaviorOfKnoBlockAdmin();
    // describeBehaviorOfKnoBlockView();
  });
}
