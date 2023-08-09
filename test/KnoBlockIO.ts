import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { IKnoBlock } from '../typechain-types';
import { ethers } from 'hardhat';
import { BigNumber, ContractTransaction } from 'ethers';
import { expect } from 'chai';

export interface KnoBlockIOBehaviorArgs {}

export function describeBehaviorOfKnoBlockIO(deploy: () => Promise<IKnoBlock>) {
  describe('KnoBlockIO contract', function () {
    describe('KnoBlockIO', function () {
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

      describe('Deployment', function () {
        it('sets the right owner', async function () {
          const owner = await instance.connect(deployer).owner();
          expect(deployer.address).to.equal(owner);
        });
      });

      describe('#create()', () => {
        it('increments the count variable by 1', async function () {
          await instance.connect(deployer).create(1001, one);
          expect(await instance.connect(deployer).count()).to.equal(one);
        });

        it('sets creator as msg.sender', async function () {
          await instance.connect(deployer).create(1001, one);
          expect(await instance.connect(deployer).creator(zero)).to.equal(
            deployer.address,
          );
        });

        it('sets unlockAmount correctly', async function () {
          await instance.connect(deployer).create(1001, one);
          expect(await instance.connect(deployer).unlockAmount(zero)).to.equal(
            BigNumber.from('1001'),
          );
        });

        it('sets knoType correctly', async function () {
          await instance.connect(deployer).create(1001, one);
          expect(await instance.connect(deployer).knoType(zero)).to.equal(one);
        });
        it('emits new KnoBlock Event', async function () {
          await expect(instance.connect(deployer).create(1001, one))
            .to.emit(instance, 'KnoBlockCreated')
            .withArgs(zero);
        });
      });
      describe('#deposit()', () => {
        it('increases the KnoBlocks currentAmount by msg.value - fee', async function () {
          const msgvalue = ethers.utils.parseUnits('1001', 0);
          await instance.connect(deployer).create(1001, one);
          await instance.connect(deployer).setDepositFeeBP(185);
          await instance.connect(deployer).deposit(zero, { value: msgvalue });

          const feeBP = await instance.connect(deployer).depositFeeBP();
          const fee = msgvalue.mul(feeBP).div(BASIS);
          const expectedNetAmount = msgvalue.sub(fee);

          expect(await instance.connect(deployer).currentAmount(zero)).to.equal(
            expectedNetAmount,
          );
        });
        it('updates msg.senders deposit value accurately', async function () {
          const msgvalue = ethers.utils.parseUnits('1001', 0);
          await instance.connect(deployer).create(1001, one);
          await instance.connect(deployer).setDepositFeeBP(185);
          await instance.connect(deployer).deposit(zero, { value: msgvalue });

          const feeBP = await instance.connect(deployer).depositFeeBP();
          const fee = msgvalue.mul(feeBP).div(BASIS);
          const expectedNetAmount = msgvalue.sub(fee);

          expect(
            await instance.connect(deployer).deposits(zero, deployer.address),
          ).to.equal(expectedNetAmount);
        });
        it('emits unlock event if currentAmount is equal to UnlockAmount', async function () {
          const msgvalue = ethers.utils.parseUnits('10001', 0);
          await instance.connect(deployer).create(1001, one);
          await instance.connect(deployer).setDepositFeeBP(185);
          await expect(
            instance.connect(deployer).deposit(zero, { value: msgvalue }),
          )
            .to.emit(instance, 'BlockUnlocked')
            .withArgs(zero);
        });
        it('returns deposit overkill to Msg.sender', async function () {
          const msgvalue = ethers.utils.parseUnits('2000', 0);
          const unlockAmount = ethers.utils.parseUnits('1001', 0);
          await instance.connect(deployer).create(1001, one);
          await instance.connect(deployer).setDepositFeeBP(185);

          // To calculate change in users Balance
          const feeBP = await instance.connect(deployer).depositFeeBP();
          const fee = msgvalue.mul(feeBP).div(BASIS);
          const expectedAmount = unlockAmount.add(fee);
          //
          await expect(
            instance.connect(deployer).deposit(zero, { value: msgvalue }),
          ).to.changeEtherBalance(deployer, -expectedAmount);
        });
        describe('reverts if...', () => {
          it('fails transaction in KnoBlock is already Unlocked', async function () {
            const msgvalue = ethers.utils.parseUnits('2000', 0);
            await instance.connect(deployer).create(1001, one);
            await instance.connect(deployer).setDepositFeeBP(185);
            await instance.connect(deployer).deposit(zero, { value: msgvalue });
            await expect(
              instance.connect(bob).deposit(zero, { value: msgvalue }),
            ).to.be.revertedWithCustomError(instance, 'KnoBlockUnlocked');
          });
        });
      });
      describe('#withdraw()', () => {
        it('reduces KnoBlocks currentAmount by amount withdrawn', async function () {
          const msgvalue = ethers.utils.parseUnits('1000', 0);
          await instance.connect(deployer).create(10000, one);
          await instance.connect(deployer).setWithdrawFeeBP(185);
          await instance.connect(bob).deposit(zero, { value: msgvalue });
          await instance.connect(bob).withdraw(zero, 1000);
          expect(await instance.connect(deployer).currentAmount(zero)).to.equal(
            zero,
          );
        });
        it('reduces users deposit amount by withdrawn amount', async function () {
          const msgvalue = ethers.utils.parseUnits('1000', 0);
          await instance.connect(deployer).create(1001, one);
          await instance.connect(deployer).setDepositFeeBP(0);
          await instance.connect(deployer).setWithdrawFeeBP(185);
          await instance.connect(bob).deposit(zero, { value: msgvalue });
          await instance.connect(bob).withdraw(zero, 1000);
          expect(
            await instance.connect(deployer).deposits(zero, bob.address),
          ).to.equal(zero);
        });
        it('transfers withdrawn amount after fee to msg.sender', async function () {
          const msgvalue = ethers.utils.parseUnits('1000', 0);
          await instance.connect(deployer).create(1001, one);
          await instance.connect(deployer).setDepositFeeBP(0);
          await instance.connect(deployer).setWithdrawFeeBP(185);
          await instance.connect(bob).deposit(zero, { value: msgvalue });

          const feeBP = await instance.connect(deployer).withdrawFeeBP();
          const fee = msgvalue.mul(feeBP).div(BASIS);
          const expectedAmount = msgvalue.sub(fee);

          await expect(
            instance.connect(bob).withdraw(zero, 1000),
          ).to.changeEtherBalance(bob, expectedAmount);
        });

        describe('reverts if...', () => {
          it('KnoBlock is Currently Unlocked', async function () {
            const msgvalue = ethers.utils.parseUnits('10000', 0);
            await instance.connect(deployer).create(1001, one);
            await instance.connect(deployer).setDepositFeeBP(185);
            await instance.connect(deployer).setWithdrawFeeBP(185);
            await instance.connect(bob).deposit(zero, { value: msgvalue });
            await expect(
              instance.connect(bob).withdraw(zero, 1000),
            ).to.be.revertedWithCustomError(instance, 'KnoBlockUnlocked');
          });
          it('attempted withdrawl is larger the deposit', async function () {
            const msgvalue = ethers.utils.parseUnits('1000', 0);
            await instance.connect(deployer).create(1001, one);
            await instance.connect(deployer).setDepositFeeBP(185);
            await instance.connect(deployer).setWithdrawFeeBP(185);
            await instance.connect(bob).deposit(zero, { value: msgvalue });
            await expect(
              instance.connect(bob).withdraw(zero, 2000),
            ).to.be.revertedWithCustomError(instance, 'InvalidAmount');
          });
        });
      });
      describe('#cancel()', () => {
        it('deletes the KnoBlock', async function () {
          await instance.connect(deployer).create(1001, one);
          await instance.connect(deployer).cancel(zero);
          expect(await instance.connect(deployer).cancelled(zero)).to.be.true;
        });
        describe('reverts if...', () => {
          it('msg.sender is not the creator of the KnoBlock', async function () {
            await instance.connect(deployer).create(1001, one);
            await expect(
              instance.connect(bob).cancel(zero),
            ).to.be.revertedWithCustomError(instance, 'NotKnoBlockOwner');
          });
          it('KnoBlock has been unlocked', async function () {
            const msgvalue = ethers.utils.parseUnits('10000', 0);
            await instance.connect(deployer).create(1001, one);
            await instance.connect(deployer).setDepositFeeBP(185);
            await instance.connect(deployer).deposit(zero, { value: msgvalue });
            await expect(
              instance.connect(deployer).cancel(zero),
            ).to.be.revertedWithCustomError(instance, 'KnoBlockUnlocked');
          });
        });
      });
      describe('#claim()', () => {
        it('transfers unlockAmount to creator', async function () {
          const msgvalue = ethers.utils.parseUnits('10000', 0);
          const expectedAmount = ethers.utils.parseUnits('1001', 0);
          await instance.connect(deployer).create(1001, one);
          await instance.connect(deployer).setDepositFeeBP(185);
          await instance.connect(bob).deposit(zero, { value: msgvalue });
          await expect(
            instance.connect(deployer).claim(zero),
          ).to.changeEtherBalance(deployer, expectedAmount);
        });
        it('deletes the KnoBlock', async function () {
          const msgvalue = ethers.utils.parseUnits('2000', 0);
          await instance.connect(deployer).create(1001, one);
          await instance.connect(deployer).setDepositFeeBP(185);
          await instance.connect(bob).deposit(zero, { value: msgvalue });
          await instance.connect(deployer).claim(zero);
          expect(await instance.connect(deployer).cancelled(zero)).to.be.true;
        });

        describe('reverts if...', () => {
          it('msg.sender is not the creator of the KnoBlock', async function () {
            const msgvalue = ethers.utils.parseUnits('2000', 0);
            await instance.connect(deployer).create(1001, one);
            await instance.connect(deployer).setDepositFeeBP(185);
            await instance.connect(bob).deposit(zero, { value: msgvalue });
            await expect(
              instance.connect(bob).claim(zero),
            ).to.be.revertedWithCustomError(instance, 'NotKnoBlockOwner');
          });
          it('KnoBlock is still locked', async function () {
            await instance.connect(deployer).create(1001, one);
            await expect(
              instance.connect(deployer).claim(zero),
            ).to.be.revertedWithCustomError(instance, 'KnoBlockLocked');
          });
          it('KnoBlock is deleted', async function () {
            const msgvalue = ethers.utils.parseUnits('1000', 0);
            await instance.connect(deployer).create(1001, one);
            await instance.connect(deployer).setDepositFeeBP(185);
            await instance.connect(bob).deposit(zero, { value: msgvalue });
            await instance.connect(deployer).cancel(zero);
            await expect(
              instance.connect(deployer).claim(zero),
            ).to.be.revertedWithCustomError(instance, 'KnoBlockCancelled');
          });
        });
      });
    });
  });
}
