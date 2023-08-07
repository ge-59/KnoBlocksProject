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
          await instance.connect(deployer).setOwner(bob.address);
          expect(await instance.connect(deployer).owner()).to.equal(
            bob.address,
          );
        });
      });
      describe('#setWithdrawFeeBP()', function () {
        it('sets the withdraw fee', async function () {
          await instance.connect(deployer).setWithdrawFeeBP(5);
          expect(await instance.connect(deployer).withdrawFeeBP()).to.equal(5);
        });
      });
      describe('#setDepositFeeBP()', function () {
        it('sets the deposit fee', async function () {
          await instance.connect(deployer).setDepositFeeBP(5);
          expect(await instance.connect(deployer).depositFeeBP()).to.equal(5);
        });
      });
      describe('#withdrawBalance()', function () {
        it('withdraws contract balance', async function () {
          const msgvalue = ethers.utils.parseUnits('1001', 0);
          await instance.connect(bob).create(1001, one);
          await instance.connect(bob).deposit(zero, { value: msgvalue });
          expect(
            instance.connect(deployer).withdrawBalance,
          ).to.changeEtherBalance(deployer, msgvalue);
        });
      });
    });
  });
}
