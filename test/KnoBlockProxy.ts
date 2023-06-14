import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import {
  IKnoBlock,
  IKnoBlock__factory,
  KnoBlockDiamond,
  KnoBlockDiamond__factory,
  KnoBlockView__factory,
  KnoBlockIO__factory,
  KnoBlockAdmin__factory,
  MockKnoBlockIO,
  MockKnoBlockIO__factory,
} from '../typechain-types';
import { ethers } from 'hardhat';
import { BigNumber, ContractTransaction } from 'ethers';
import { expect } from 'chai';

describe('KnoBlockProxy', function () {
  let deployer: SignerWithAddress;
  let addr1: SignerWithAddress;
  let addr2: SignerWithAddress;
  let instance: IKnoBlock;
  let diamond: KnoBlockDiamond;
  let contract: MockKnoBlockIO;

  const zero = ethers.constants.Zero;
  const one = ethers.constants.One;

  before(async function () {
    [deployer, addr1, addr2] = await ethers.getSigners();

    const adminFacetCuts = [
      await new MockKnoBlockIO__factory(deployer).deploy(),
    ].map(function (f) {
      return {
        target: f.address,
        action: 0,
        selectors: Object.keys(f.interface.functions).map((fn) =>
          f.interface.getSighash(fn),
        ),
      };
    });

    beforeEach(async function () {
      contract = await new MockKnoBlockIO__factory(deployer).deploy();
      diamond = await new KnoBlockDiamond__factory(deployer).deploy(500, 500);
      Admin = await new KnoBlockAdmin__factory(deployer).deploy();
      instance = await new IKnoBlock__factory(deployer).deploy();

      const factory = await ethers.getContractFactory('MockKnoBlockIO');

      const adminFacetCuts = [
        await new KnoBlockAdmin__factory(deployer).deploy(),
      ].map(function (f) {
        return {
          target: f.address,
          action: 0,
          selectors: Object.keys(f.interface.functions).map((fn) =>
            f.interface.getSighash(fn),
          ),
        };
      });
    });

    describe('#diamondCut', function () {
      it('cuts', async function () {
        diamond.diamondCut(adminFacetCuts, ethers.constants.AddressZero, '0x');
        await instance.setOwner(addr1.address);
      });
    });
  });
});

ethers.getContractAt 

wrap diamond 

if (!receipt.status) {
  throw Error(`Diamond upgrade failed: ${tx.hash}`);
}