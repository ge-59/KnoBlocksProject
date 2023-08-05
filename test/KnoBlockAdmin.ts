import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { IKnoBlock } from '../typechain-types';
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
      let bob: SignerWithAddress;
      let alice: SignerWithAddress;
      let instance: IKnoBlock;

      const zero = ethers.constants.Zero;
      const one = ethers.constants.One;

      before(async function () {
        [deployer, bob, alice] = await ethers.getSigners();
      });

      beforeEach(async function () {
        instance = await deploy();
      });

      describe('#setOwner()', function () {
        it('sets the right owner', async function () {
          await instance.setOwner(bob.address);
          expect(await instance.owner()).to.equal(bob.address);
        });
      });
      describe('#setWithdrawFeeBP()', function () {
        it('sets the withdraw fee', async function () {
          await instance.setWithdrawFeeBP(5);
          expect(await instance.withdrawFeeBP()).to.equal(5);
        });
      });
      describe('#setDepositFeeBP()', function () {
        it('sets the deposit fee', async function () {
          await instance.setDepositFeeBP(5);
          expect(await instance.depositFeeBP()).to.equal(5);
        });
      });
      describe('#withdrawBalance()', function () {
        it('withdraws contract balance', async function () {
          const msgvalue = ethers.utils.parseUnits('1001', 0);
          await instance.connect(bob).create(1001, one);
          await instance.connect(bob).deposit(zero, { value: msgvalue });
          expect(instance.withdrawBalance).to.changeEtherBalance(
            deployer,
            msgvalue,
          );
        });
      });
    });
  });
}
