import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import {
  KnoBlockDiamond,
  KnoBlockDiamond__factory,
  KnoBlockView,
  KnoBlockView__factory,
  KnoBlockIO,
  KnoBlockIO__factory,
  KnoBlockAdmin__factory,
} from '../typechain-types';
import { ethers } from 'hardhat';
import { BigNumber, ContractTransaction } from 'ethers';
import { expect } from 'chai';

describe('KnoBlockProxy', function () {
  let deployer: SignerWithAddress;
  let addr1: SignerWithAddress;
  let addr2: SignerWithAddress;
  let diamond: KnoBlockDiamond;
  let snapshotId: number;

  const zero = ethers.constants.Zero;
  const one = ethers.constants.One;

  before(async function () {
    [deployer, addr1, addr2] = await ethers.getSigners();

    diamond = await new KnoBlockDiamond__factory(deployer).deploy(1000, 1000);

    const FacetCuts = [
      await new KnoBlockIO__factory(deployer).deploy(),
      await new KnoBlockAdmin__factory(deployer).deploy(),
      await new KnoBlockView__factory(deployer).deploy(),
    ].map(function (f) {
      return {
        target: f.address,
        action: 0,
        selectors: Object.keys(f.interface.functions).map((fn) =>
          f.interface.getSighash(fn),
        ),
      };
    });

    await diamond.diamondCut(FacetCuts, ethers.constants.AddressZero, '0x');
  });
  beforeEach(async function () {
    snapshotId = await ethers.provider.send('evm_snapshot', []);
  });

  afterEach(async function () {
    await ethers.provider.send('evm_revert', [snapshotId]);
  });
});
