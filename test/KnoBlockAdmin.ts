import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import {
  IKnoBlock,
  MockKnoBlockIO,
  MockKnoBlockIO__factory,
} from '../typechain-types';
import { ethers } from 'hardhat';
import { BigNumber, ContractTransaction } from 'ethers';
import { expect } from 'chai';

export interface KnoBlockAdminBehaviorArgs {}

export function describeBehaviorOfKnoBlockAdmin(
  deploy: () => Promise<IKnoBlock>,
) {
  describe('KnoBlockAdmin contract', function () {
    describe('KnoBlockAdmin', function () {
      let deployer: SignerWithAddress;
      let addr1: SignerWithAddress;
      let addr2: SignerWithAddress;
      let instance: IKnoBlock;

      const zero = ethers.constants.Zero;
      const one = ethers.constants.One;

      before(async function () {
        [deployer, addr1, addr2] = await ethers.getSigners();
      });

      beforeEach(async function () {
        instance = await deploy();
      });

      describe('#ownerSet()', function () {
        it('sets the right owner', async function () {
          await instance.setOwner(addr1.address);
          expect(await instance.owner()).to.equal(addr1.address);
        });
      });
      describe('#setWithdrawFee()', function () {
        it('sets the withdraw fee', async function () {
          await instance.setWithdrawFee(5);
          expect(await instance.withdrawFees()).to.equal(5);
        });
      });
      describe('#setDepositFee()', function () {
        it('sets the deposit fee', async function () {
          await instance.setDepositFee(5);
          expect(await instance.depositFees()).to.equal(5);
        });
      });
      describe('#withdrawBalance()', function () {
        it('withdraws contract balance', async function () {
          const msgvalue = ethers.utils.parseUnits('1001', 0);
          await instance.connect(addr1).create(1001, one);
          await instance.connect(addr1).deposit(zero, { value: msgvalue });
          expect(instance.withdrawBalance).to.changeEtherBalance(
            deployer,
            msgvalue,
          );
        });
      });
    });
  });
}
