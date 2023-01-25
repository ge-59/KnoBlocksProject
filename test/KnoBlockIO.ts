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

    before(async function () {
      [deployer, addr1, addr2] = await ethers.getSigners();
    });

    beforeEach(async function () {
      instance = await new MockKnoBlockIO__factory(deployer).deploy();
    });

    describe('Deployment', function () {
      // Does not set the "owner" in KnoBlock Storage, but in Ownable. So do we even need the one in KnoBlockStorage?
      it('sets the right owner', async function () {
        const owner = await instance.MockOwner();
        expect(deployer.address).to.equal(owner);
      });
    });

    describe('#createKnoBlock()', () => {
      it('increments the count variable by 1', async function () {
        await instance.create(1001, 1);
        expect(await instance.MockCount()).to.equal(1); //use constants
      });

      it('sets creator as msg.sender', async function () {
        await instance.create(1001, 1);
        expect(await instance.MockCreator(0)).to.equal(
          deployer.address,
        );
      });

      it('sets unlockAmount to correctly', async function () {
        await instance.create(1001, 1);
        expect(await instance.MockUnlockAmount(0)).to.equal(1001);
      });

      it('sets knoType to correctly', async function () {
        await instance.create(1001, 1);
        expect(await instance.MockType(0)).to.equal(1);
      });
      it('emits new KnoBlock Event', async function () {
        expect(await instance.create(1001, 1))
          .to.emit(instance, 'NewKnoBlock')
          .withArgs(0);
      });
    });
    describe('#deposit()', () => {
      it('increases the KnoBlocks currentAmount by msg.value', async function () {
        const msgvalue = {
          value: ethers.utils.parseEther('0.000000000000001'),
        }; //sending 1000 wei
        await instance.create(1001, 1);
        await instance.deposit(0, msgvalue);
        expect(await instance.MockCurrentAmount(0)).to.equal(
          1000,
        );
      });
      it('updates msg.senders deposit value accurately', async function () {
        const msgvalue = {
          value: ethers.utils.parseEther('0.000000000000001'),
        }; //sending 1000 wei
        await instance.create(1001, 1);
        await instance.deposit(0, msgvalue);
        expect(await instance.MockDeposits(0)).to.equal(1000);
      });

      it('unlocks the Knoblock if currentAmount is equal to UnlockAmount', async function () {
        const msgvalue = {
          value: ethers.utils.parseEther('0.000000000000001001'),
        }; //sending 1001 wei
        await instance.create(1001, 1);
        await instance.deposit(0, msgvalue);
        expect(await instance.MockUnlocked(0)).to.be.true;
      });

      it('emits unlock event if currentAmount is equal to UnlockAmount', async function () {
        const msgvalue = {
          value: ethers.utils.parseEther('0.000000000000001001'),
        }; //sending 1001 wei
        await instance.create(1001, 1);
        expect(await instance.deposit(0, msgvalue))
          .to.emit(instance, 'BlockUnlocked')
          .withArgs(0);
      });

      it('unlocks the Knoblock if currentAmount is greater to UnlockAmount', async function () {
        const msgvalue = {
          value: ethers.utils.parseEther('0.000000000000002000'),
        }; //sending 2000 wei
        await instance.create(1001, 1);
        await instance.deposit(0, msgvalue);
        expect(await instance.MockUnlocked(0)).to.be.true;
      });

      it('emits unlock event if currentAmount is equal to UnlockAmount', async function () {
        const msgvalue = {
          value: ethers.utils.parseEther('0.000000000000002000'),
        }; //sending 2000 wei
        await instance.create(1001, 1);
        expect(await instance.deposit(0, msgvalue))
          .to.emit(instance, 'BlockUnlocked')
          .withArgs(0);
      });

      it('returns deposit overkill to Msg.sender', async function () {
        const msgvalue = {
          value: ethers.utils.parseEther('0.000000000000002000'),
        }; //sending 2000 wei
        await instance.create(1001, 1);
        expect(await instance.deposit(0, msgvalue)).to.changeEtherBalance(
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
          await instance.deposit(0, msgvalue);
          await expect(
            instance.connect(addr1).deposit(0, msgvalue),
          ).to.be.revertedWithCustomError(instance, 'KnoBlockUnlocked');
          // WHATTTTTT, needed the await before the expect or DANK error ??? HUH
        });
      });
      describe('#withdraw()', () => {
        it('reduces KnoBlocks currentAmount by amount withdrawn', async function () {
          const msgvalue = {
            value: ethers.utils.parseEther('0.000000000000001000'),
          }; //sending 1000 wei
          await instance.create(1001, 1);
          await instance.connect(addr1).deposit(0, msgvalue);
          await instance.connect(addr1).withdraw(0, 1000);
          expect(await instance.MockCurrentAmount(0)).to.equal(0);
        });
        it('reduces users deposit amount by withdrawn amount', async function () {
          const msgvalue = {
            value: ethers.utils.parseEther('0.000000000000001000'),
          }; //sending 1000 wei
          await instance.create(1001, 1);
          await instance.connect(addr1).deposit(0, msgvalue);
          await instance.connect(addr1).withdraw(0, 1000);
          expect(await instance.MockDeposits(0)).to.equal(0);
        });
        it('transfers withdrawn amount to msg.sender', async function () {
          const msgvalue = {
            value: ethers.utils.parseEther('0.000000000000001000'),
          }; //sending 1000 wei
          await instance.create(1001, 1);
          await instance.connect(addr1).deposit(0, msgvalue);
          expect(
            await instance.connect(addr1).withdraw(0, 1000),
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
        await instance.connect(addr1).deposit(0, msgvalue);
        await expect(
          instance.connect(addr1).withdraw(0, 1001),
        ).to.be.revertedWithCustomError(instance, 'KnoBlockUnlocked');
      });
      it('attempted withdrawl is larger the deposit', async function () {
        const msgvalue = {
          value: ethers.utils.parseEther('0.000000000000001000'),
        }; //sending 1000 wei
        await instance.create(1001, 1);
        await instance.connect(addr1).deposit(0, msgvalue);
        await expect(
          instance.connect(addr1).withdraw(0, 2000),
        ).to.be.revertedWithCustomError(instance, 'InvalidWithdraw');
      });
    });
    describe('#delete()', () => {
      it('deletes a KnoBlock', async function () {
        await instance.create(1001, 1);
        await instance.cancel(0);
        expect(await instance.MockCancelled(0)).to.be.true;
      });
    });
    describe('reverts if...', () => {
      it('msg.sendor is not the creator of the KnoBlock', async function () {
        await instance.connect(addr1).create(1001, 1);
        expect(
          await instance.MockCancelled(0),
        ).to.be.revertedWithCustomError(instance, 'NotKnoBlockOwner');
      });
    });
    describe('#claim()', () => {
      it('transfers unlockAmount to creator', async function () {
        const msgvalue = {
          value: ethers.utils.parseEther('0.000000000000001001'),
        }; //sending 1001 wei
        await instance.create(1001, 1);
        await instance.connect(addr1).deposit(0, msgvalue);
        expect(await instance.claim(0)).to.changeEtherBalance(
          deployer,
          msgvalue,
        );
      });
      it('deletes the KnoBlock', async function () {
        const msgvalue = {
          value: ethers.utils.parseEther('0.000000000000001001'),
        }; //sending 1001 wei
        await instance.create(1001, 1);
        await instance.connect(addr1).deposit(0, msgvalue);
        await instance.claim(0);
        expect(await instance.MockCancelled(0)).to.be.true;
      });
    });
    describe('reverts if...', () => {
      it('msg.sendor is not the creator of the KnoBlock', async function () {
        const msgvalue = {
          value: ethers.utils.parseEther('0.000000000000001001'),
        }; //sending 1001 wei
        await instance.create(1001, 1);
        await instance.connect(addr1).deposit(0, msgvalue);
        await expect(
          instance.connect(addr1).claim(0),
        ).to.be.revertedWithCustomError(instance, 'NotKnoBlockOwner');
      });
      it('KnoBlock is still locked', async function () {
        const msgvalue = {
          value: ethers.utils.parseEther('0.000000000000001001'),
        }; //sending 1001 wei
        await instance.create(1001, 1);
        await expect(instance.claim(0)).to.be.revertedWithCustomError(
          instance,
          'KnoBlockLocked',
        );
      });
      it('KnoBlock is deleted', async function () {
        const msgvalue = {
          value: ethers.utils.parseEther('0.000000000000001000'),
        }; //sending 1000 wei
        await instance.create(1001, 1);
        await instance.connect(addr1).deposit(0, msgvalue);
        await instance.cancel(0);
        await expect(instance.claim(0)).to.be.revertedWithCustomError(
          instance,
          'KnoBlockCancelled',
        );
      });
    });
  });
});
