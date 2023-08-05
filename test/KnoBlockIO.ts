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

      describe('Deployment', function () {
        it('sets the right owner', async function () {
          const owner = await instance.owner();
          expect(deployer.address).to.equal(owner);
        });
      });

      describe('#create()', () => {
        it('increments the count variable by 1', async function () {
          await instance.create(1001, one);
          expect(await instance.count()).to.equal(one);
        });

        it('sets creator as msg.sender', async function () {
          await instance.create(1001, one);
          expect(await instance.creator(zero)).to.equal(deployer.address);
        });

        it('sets unlockAmount to correctly', async function () {
          await instance.create(1001, one);
          expect(await instance.unlockAmount(zero)).to.equal(
            BigNumber.from('1001'),
          );
        });

        it('sets knoType to correctly', async function () {
          await instance.create(1001, one);
          expect(await instance.knoType(zero)).to.equal(one);
        });
        it('emits new KnoBlock Event', async function () {
          await expect(instance.create(1001, one))
            .to.emit(instance, 'KnoBlockCreated')
            .withArgs(zero);
        });
      });
      describe('#deposit()', () => {
        it('increases the KnoBlocks currentAmount by msg.value - fee', async function () {
          const msgvalue = ethers.utils.parseUnits('1001', 0);
          await instance.create(1001, one);
          await instance.setDepositFeeBP(185);
          await instance.deposit(zero, { value: msgvalue });

          const depositedAmount = msgvalue;
          const fee = depositedAmount.mul(185).div(10000);
          const expectedNetAmount = depositedAmount.sub(fee);

          expect(await instance.currentAmount(zero)).to.equal(
            expectedNetAmount,
          );
        });
        it('updates msg.senders deposit value accurately', async function () {
          const msgvalue = ethers.utils.parseUnits('1001', 0);
          await instance.create(1001, one);
          await instance.setDepositFeeBP(185);
          await instance.deposit(zero, { value: msgvalue });

          const depositedAmount = msgvalue;
          const fee = depositedAmount.mul(185).div(10000);
          const expectedNetAmount = depositedAmount.sub(fee);

          expect(await instance.deposits(zero, deployer.address)).to.equal(
            expectedNetAmount,
          );
        });
        it('emits unlock event if currentAmount is equal to UnlockAmount', async function () {
          const msgvalue = ethers.utils.parseUnits('10001', 0);
          await instance.create(1001, one);
          await instance.setDepositFeeBP(185);
          await expect(instance.deposit(zero, { value: msgvalue }))
            .to.emit(instance, 'BlockUnlocked')
            .withArgs(zero);
        });
        it('returns deposit overkill to Msg.sender', async function () {
          const msgvalue = ethers.utils.parseUnits('2000', 0);
          const unlockAmount = ethers.utils.parseUnits('1001', 0);
          await instance.create(1001, one);
          await instance.setDepositFeeBP(185);

          // To calculate change in users Balance
          const fee = msgvalue.mul(185).div(10000);
          const expectedAmount = unlockAmount.add(fee);
          //
          await expect(
            instance.deposit(zero, { value: msgvalue }),
          ).to.changeEtherBalance(deployer, -expectedAmount);
        });
        describe('reverts if...', () => {
          it('fails transaction in KnoBlock is already Unlocked', async function () {
            const msgvalue = ethers.utils.parseUnits('2000', 0);
            await instance.create(1001, one);
            await instance.setDepositFeeBP(185);
            await instance.deposit(zero, { value: msgvalue });
            await expect(
              instance.connect(addr1).deposit(zero, { value: msgvalue }),
            ).to.be.revertedWithCustomError(instance, 'KnoBlockUnlocked');
          });
        });
      });
      describe('#withdraw()', () => {
        it('reduces KnoBlocks currentAmount by amount withdrawn', async function () {
          const msgvalue = ethers.utils.parseUnits('1000', 0);
          await instance.create(10000, one);
          await instance.setWithdrawFeeBP(185);
          await instance.connect(addr1).deposit(zero, { value: msgvalue });
          await instance.connect(addr1).withdraw(zero, 1000);
          expect(await instance.currentAmount(zero)).to.equal(zero);
        });
        it('reduces users deposit amount by withdrawn amount', async function () {
          const msgvalue = ethers.utils.parseUnits('1000', 0);
          await instance.create(1001, one);
          await instance.setDepositFeeBP(0);
          await instance.setWithdrawFeeBP(185);
          await instance.connect(addr1).deposit(zero, { value: msgvalue });
          await instance.connect(addr1).withdraw(zero, 1000);
          expect(await instance.deposits(zero, addr1.address)).to.equal(zero);
        });
        it('transfers withdrawn amount after fee to msg.sender', async function () {
          const msgvalue = ethers.utils.parseUnits('1000', 0);
          await instance.create(1001, one);
          await instance.setDepositFeeBP(0);
          await instance.setWithdrawFeeBP(185);
          await instance.connect(addr1).deposit(zero, { value: msgvalue });

          const fee = msgvalue.mul(185).div(10000);
          const expectedAmount = msgvalue.sub(fee);

          await expect(
            instance.connect(addr1).withdraw(zero, 1000),
          ).to.changeEtherBalance(addr1, expectedAmount);
        });

        describe('reverts if...', () => {
          it('KnoBlock is Currently Unlocked', async function () {
            const msgvalue = ethers.utils.parseUnits('10000', 0);
            await instance.create(1001, one);
            await instance.setDepositFeeBP(185);
            await instance.setWithdrawFeeBP(185);
            await instance.connect(addr1).deposit(zero, { value: msgvalue });
            await expect(
              instance.connect(addr1).withdraw(zero, 1000),
            ).to.be.revertedWithCustomError(instance, 'KnoBlockUnlocked');
          });
          it('attempted withdrawl is larger the deposit', async function () {
            const msgvalue = ethers.utils.parseUnits('1000', 0);
            await instance.create(1001, one);
            await instance.setDepositFeeBP(185);
            await instance.setWithdrawFeeBP(185);
            await instance.connect(addr1).deposit(zero, { value: msgvalue });
            await expect(
              instance.connect(addr1).withdraw(zero, 2000),
            ).to.be.revertedWithCustomError(instance, 'InvalidAmount');
          });
        });
      });
      describe('#cancel()', () => {
        it('deletes the KnoBlock', async function () {
          await instance.create(1001, one);
          await instance.cancel(zero);
          expect(await instance.cancelled(zero)).to.be.true;
        });
        describe('reverts if...', () => {
          it('msg.sender is not the creator of the KnoBlock', async function () {
            await instance.create(1001, one);
            await expect(
              instance.connect(addr1).cancel(zero),
            ).to.be.revertedWithCustomError(instance, 'NotKnoBlockOwner');
          });
          it('KnoBlock has been unlocked', async function () {
            const msgvalue = ethers.utils.parseUnits('10000', 0);
            await instance.create(1001, one);
            await instance.setDepositFeeBP(185);
            await instance.deposit(zero, { value: msgvalue });
            await expect(instance.cancel(zero)).to.be.revertedWithCustomError(
              instance,
              'KnoBlockUnlocked',
            );
          });
        });
      });
      describe('#claim()', () => {
        it('transfers unlockAmount to creator', async function () {
          const msgvalue = ethers.utils.parseUnits('10000', 0);
          const expectedAmount = ethers.utils.parseUnits('1001', 0);
          await instance.create(1001, one);
          await instance.setDepositFeeBP(185);
          await instance.connect(addr1).deposit(zero, { value: msgvalue });
          await expect(instance.claim(zero)).to.changeEtherBalance(
            deployer,
            expectedAmount,
          );
        });
        it('deletes the KnoBlock', async function () {
          const msgvalue = ethers.utils.parseUnits('2000', 0);
          await instance.create(1001, one);
          await instance.setDepositFeeBP(185);
          await instance.connect(addr1).deposit(zero, { value: msgvalue });
          await instance.claim(zero);
          expect(await instance.cancelled(zero)).to.be.true;
        });

        describe('reverts if...', () => {
          it('msg.sender is not the creator of the KnoBlock', async function () {
            const msgvalue = ethers.utils.parseUnits('2000', 0);
            await instance.create(1001, one);
            await instance.setDepositFeeBP(185);
            await instance.connect(addr1).deposit(zero, { value: msgvalue });
            await expect(
              instance.connect(addr1).claim(zero),
            ).to.be.revertedWithCustomError(instance, 'NotKnoBlockOwner');
          });
          it('KnoBlock is still locked', async function () {
            await instance.create(1001, one);
            await expect(instance.claim(zero)).to.be.revertedWithCustomError(
              instance,
              'KnoBlockLocked',
            );
          });
          it('KnoBlock is deleted', async function () {
            const msgvalue = ethers.utils.parseUnits('1000', 0);
            await instance.create(1001, one);
            await instance.setDepositFeeBP(185);
            await instance.connect(addr1).deposit(zero, { value: msgvalue });
            await instance.cancel(zero);
            await expect(instance.claim(zero)).to.be.revertedWithCustomError(
              instance,
              'KnoBlockCancelled',
            );
          });
        });
      });
    });
  });
}
