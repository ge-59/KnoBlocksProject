import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { IKnoBlock } from '../typechain-types';
import { ethers } from 'hardhat';
import { BigNumber, ContractTransaction } from 'ethers';
import { expect } from 'chai';

export interface KnoBlockAdminBehaviorArgs {}

export function describeBehaviorOfKnoBlockAdmin(
  deploy: () => Promise<IKnoBlock>,
) {
  describe.only('KnoBlockAdmin contract', function () {
    describe('KnoBlockAdmin', function () {
      let deployer: SignerWithAddress;
      let bob: SignerWithAddress;
      let alice: SignerWithAddress;
      let instance: IKnoBlock;

      const zero = ethers.constants.Zero;
      const one = ethers.constants.One;
      const BASIS = 10000;

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
        describe('reverts if...', () => {
          it('fee set exceeds BASIS', async function () {
            await expect(
              instance.connect(deployer).setWithdrawFeeBP(10001),
            ).to.be.revertedWithCustomError(instance, 'Basis_Exceeded');
          });
          it('used by non-owner', async function () {
            await expect(
              instance.connect(bob).setWithdrawFeeBP(5),
            ).to.be.revertedWithCustomError(instance, 'Ownable__NotOwner');
          });
        });
      });
      describe('#setDepositFeeBP()', function () {
        it('sets the deposit fee', async function () {
          await instance.connect(deployer).setDepositFeeBP(5);
          expect(await instance.connect(deployer).depositFeeBP()).to.equal(5);
        });
        describe('reverts if...', () => {
          it('fee set exceeds BASIS', async function () {
            await expect(
              instance.connect(deployer).setDepositFeeBP(10001),
            ).to.be.revertedWithCustomError(instance, 'Basis_Exceeded');
          });
          it('used by non-owner', async function () {
            await expect(
              instance.connect(bob).setDepositFeeBP(5),
            ).to.be.revertedWithCustomError(instance, 'Ownable__NotOwner');
          });
        });
      });
      describe('#withdrawFees()', function () {
        it('withdraws accrued fees', async function () {
          const msgvalue = ethers.utils.parseUnits('1000', 0);
          await instance.connect(deployer).setDepositFeeBP(1000);
          await instance.connect(bob).create(1001, one);
          await instance.connect(bob).deposit(zero, { value: msgvalue });

          const feeBP = await instance.connect(deployer).depositFeeBP();
          const fee = msgvalue.mul(feeBP).div(BASIS);

          await expect(
            instance.connect(deployer).withdrawFees,
          ).to.changeEtherBalance(deployer, fee);
        });
        describe('reverts if...', () => {
          it('used by non-owner', async function () {
            await expect(
              instance.connect(bob).withdrawFees,
            ).to.be.revertedWithCustomError(instance, 'Ownable__NotOwner');
          });
        });
      });
    });
  });
}
