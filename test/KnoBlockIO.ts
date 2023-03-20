import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { MockKnoBlockIO, MockKnoBlockIO__factory } from '../typechain-types';
import { ethers } from 'hardhat';
import { BigNumber, ContractTransaction } from 'ethers';
import { expect } from 'chai';

describe('KnoBlockIO contract', function () {
  describe('KnoBlockIO', function () {
    let deployer: SignerWithAddress;
    let addr1: SignerWithAddress;
    let addr2: SignerWithAddress;
    let instance: MockKnoBlockIO;

    const zero = ethers.constants.Zero;
    const one = ethers.constants.One;

    before(async function () {
      [deployer, addr1, addr2] = await ethers.getSigners();
    });

    beforeEach(async function () {
      instance = await new MockKnoBlockIO__factory(deployer).deploy();
    });

    describe('Deployment', function () {
      it('sets the right owner', async function () {
        const owner = await instance.owned();
        expect(deployer.address).to.equal(owner);
      });
    });

    describe('#create()', () => {
      it('increments the count variable by 1', async function () {
        await instance.create(1001, 1);
        expect(await instance.count()).to.equal(one);
      });

      it('sets creator as msg.sender', async function () {
        await instance.create(1001, 1);
        expect(await instance.creator(zero)).to.equal(deployer.address);
      });

      it('sets unlockAmount to correctly', async function () {
        await instance.create(1001, 1);
        expect(await instance.unlockAmount(zero)).to.equal(
          BigNumber.from('1001'),
        );
      });

      it('sets knoType to correctly', async function () {
        await instance.create(1001, 1);
        expect(await instance.knoType(zero)).to.equal(one);
      });
      it('emits new KnoBlock Event', async function () {
        expect(await instance.create(1001, 1))
          .to.emit(instance, 'NewKnoBlock')
          .withArgs(zero);
      });
    });
    describe('#deposit()', () => {
      it('increases the KnoBlocks currentAmount by msg.value', async function () {
        const msgvalue = {
          value: ethers.utils.parseEther('0.000000000000001'),
        }; //sending 1000 wei
        await instance.create(1001, 1);
        await instance.deposit(zero, msgvalue);
        expect(await instance.currentAmount(zero)).to.equal(
          BigNumber.from('1000'),
        );
      });
      it('updates msg.senders deposit value accurately', async function () {
        const msgvalue = {
          value: ethers.utils.parseEther('0.000000000000001'),
        }; //sending 1000 wei
        await instance.create(1001, 1);
        await instance.deposit(zero, msgvalue);
        expect(await instance.deposits(zero, deployer.address)).to.equal(
          BigNumber.from('1000'),
        );
      });
      it('emits unlock event if currentAmount is equal to UnlockAmount', async function () {
        const msgvalue = {
          value: ethers.utils.parseEther('0.000000000000001001'),
        }; //sending 1001 wei
        await instance.create(1001, 1);
        expect(await instance.deposit(zero, msgvalue))
          .to.emit(instance, 'BlockUnlocked')
          .withArgs(zero);
      });
      it('emits unlock event if currentAmount is equal to UnlockAmount', async function () {
        const msgvalue = {
          value: ethers.utils.parseEther('0.000000000000002000'),
        }; //sending 2000 wei
        await instance.create(1001, 1);
        expect(await instance.deposit(zero, msgvalue))
          .to.emit(instance, 'BlockUnlocked')
          .withArgs(zero);
      });

      it('returns deposit overkill to Msg.sender', async function () {
        const msgvalue = {
          value: ethers.utils.parseEther('0.000000000000002000'),
        }; //sending 2000 wei
        await instance.create(1001, 1);
        expect(await instance.deposit(zero, msgvalue)).to.changeEtherBalance(
          deployer,
          -msgvalue,
        );
      });

      describe('reverts if...', () => {
        it('fails transaction in KnoBlock is already Unlocked', async function () {
          const msgvalue = {
            value: ethers.utils.parseEther('0.000000000000001001'),
          }; //sending 1001 wei
          await instance.create(1001, 1);
          await instance.deposit(zero, msgvalue);
          await expect(
            instance.connect(addr1).deposit(zero, msgvalue),
          ).to.be.revertedWithCustomError(instance, 'KnoBlockUnlocked');
        });
      });
      describe('#withdraw()', () => {
        it('reduces KnoBlocks currentAmount by amount withdrawn', async function () {
          const msgvalue = {
            value: ethers.utils.parseEther('0.000000000000001000'),
          }; //sending 1000 wei
          await instance.create(1001, 1);
          await instance.connect(addr1).deposit(zero, msgvalue);
          await instance.connect(addr1).withdraw(zero, 1000);
          expect(await instance.currentAmount(zero)).to.equal(zero);
        });
        it('reduces users deposit amount by withdrawn amount', async function () {
          const msgvalue = {
            value: ethers.utils.parseEther('0.000000000000001000'),
          }; //sending 1000 wei
          await instance.create(1001, 1);
          await instance.connect(addr1).deposit(zero, msgvalue);
          await instance.connect(addr1).withdraw(zero, 1000);
          expect(await instance.deposits(zero, addr1.address)).to.equal(zero);
        });
        it('transfers withdrawn amount to msg.sender', async function () {
          const msgvalue = {
            value: ethers.utils.parseEther('0.000000000000001000'),
          }; //sending 1000 wei
          await instance.create(1001, 1);
          await instance.connect(addr1).deposit(zero, msgvalue);
          expect(
            await instance.connect(addr1).withdraw(zero, 1000),
          ).to.changeEtherBalance(addr1, msgvalue);
        });
      });
    });
    describe('reverts if...', () => {
      it('KnoBlock is Currently Unlocked', async function () {
        const msgvalue = {
          value: ethers.utils.parseEther('0.000000000000001001'),
        }; //sending 1001 wei
        await instance.create(1001, 1);
        await instance.connect(addr1).deposit(zero, msgvalue);
        await expect(
          instance.connect(addr1).withdraw(zero, 1001),
        ).to.be.revertedWithCustomError(instance, 'KnoBlockUnlocked');
      });
      it('attempted withdrawl is larger the deposit', async function () {
        const msgvalue = {
          value: ethers.utils.parseEther('0.000000000000001000'),
        }; //sending 1000 wei
        await instance.create(1001, 1);
        await instance.connect(addr1).deposit(zero, msgvalue);
        await expect(
          instance.connect(addr1).withdraw(zero, 2000),
        ).to.be.revertedWithCustomError(instance, 'InvalidAmount');
      });
    });
    describe('#delete()', () => {
      it('deletes a KnoBlock', async function () {
        await instance.create(1001, 1);
        await instance.cancel(zero);
        expect(await instance.cancelled(zero)).to.be.true;
      });
    });
    describe('reverts if...', () => {
      it('msg.sendor is not the creator of the KnoBlock', async function () {
        await instance.connect(addr1).create(1001, 1);
        expect(await instance.cancelled(zero)).to.be.revertedWithCustomError(
          instance,
          'NotKnoBlockOwner',
        );
      });
    });
    describe('#cancel()', () => {
      it('deletes the KnoBlock', async function () {
        await instance.create(1001, 1);
        await instance.cancel(zero);
        expect(await instance.cancelled(0)).to.be.true;
      });
    });
    describe('reverts if...', () => {
      it('msg.sender is not the creator of the KnoBlock', async function () {
        await instance.create(1001, 1);
        await expect(
          instance.connect(addr1).cancel(zero),
        ).to.be.revertedWithCustomError(instance, 'NotKnoBlockOwner');
      });
      it('KnoBlock has been unlocked', async function () {
        const msgvalue = {
          value: ethers.utils.parseEther('0.000000000000001001'),
        }; //sending 1001 wei
        await instance.create(1001, 1);
        await instance.deposit(zero, msgvalue);
        await expect(instance.cancel(zero)).to.be.revertedWithCustomError(
          instance,
          'KnoBlockUnlocked',
        );
      });
      describe('#claim()', () => {
        it('transfers unlockAmount to creator', async function () {
          const msgvalue = {
            value: ethers.utils.parseEther('0.000000000000001001'),
          }; //sending 1001 wei
          await instance.create(1001, 1);
          await instance.connect(addr1).deposit(zero, msgvalue);
          expect(await instance.claim(zero)).to.changeEtherBalance(
            deployer,
            msgvalue,
          );
        });
        it('deletes the KnoBlock', async function () {
          const msgvalue = {
            value: ethers.utils.parseEther('0.000000000000001001'),
          }; //sending 1001 wei
          await instance.create(1001, 1);
          await instance.connect(addr1).deposit(zero, msgvalue);
          await instance.claim(zero);
          expect(await instance.cancelled(zero)).to.be.true;
        });
      });
      describe('reverts if...', () => {
        it('msg.sender is not the creator of the KnoBlock', async function () {
          const msgvalue = {
            value: ethers.utils.parseEther('0.000000000000001001'),
          }; //sending 1001 wei
          await instance.create(1001, 1);
          await instance.connect(addr1).deposit(zero, msgvalue);
          await expect(
            instance.connect(addr1).claim(zero),
          ).to.be.revertedWithCustomError(instance, 'NotKnoBlockOwner');
        });
        it('KnoBlock is still locked', async function () {
          const msgvalue = {
            value: ethers.utils.parseEther('0.000000000000001001'),
          }; //sending 1001 wei
          await instance.create(1001, 1);
          await expect(instance.claim(zero)).to.be.revertedWithCustomError(
            instance,
            'KnoBlockLocked',
          );
        });
        it('KnoBlock is deleted', async function () {
          const msgvalue = {
            value: ethers.utils.parseEther('0.000000000000001000'),
          }; //sending 1000 wei
          await instance.create(1001, 1);
          await instance.connect(addr1).deposit(zero, msgvalue);
          await instance.cancel(zero);
          await expect(instance.claim(zero)).to.be.revertedWithCustomError(
            instance,
            'KnoBlockisCancelled',
          );
        });
      });
    });
  });
});
