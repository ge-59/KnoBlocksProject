import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { IKnoBlock } from '../typechain-types';
import { ethers } from 'hardhat';
import { expect } from 'chai';

export interface KnoBlockViewBehaviorArgs {}

export function describeBehaviorOfKnoBlockView(
  deploy: () => Promise<IKnoBlock>,
) {
  describe('KnoBlockView contract', function () {
    describe('KnoBlockView', function () {
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

      describe('#count()', function () {
        it('returns count variable', async function () {
          await instance.create(1001, one);
          expect(await instance.count()).to.equal(one);
        });
      });
      describe('#creator()', function () {
        it('returns creator', async function () {
          await instance.connect(addr1).create(1001, one);
          expect(await instance.creator(0)).to.equal(addr1.address);
        });
      });
      describe('#unlockAmount()', function () {
        it('returns unlockAmount', async function () {
          await instance.create(1001, one);
          expect(await instance.unlockAmount(0)).to.equal(1001);
        });
      });
      describe('#currentAmount()', function () {
        it('returns currentAmount', async function () {
          const msgvalue = ethers.utils.parseUnits('1001', 0);
          await instance.create(1001, one);
          await instance.deposit(zero, { value: msgvalue });
          expect(await instance.currentAmount(0)).to.equal(1001);
        });
      });
      describe('#knoType()', function () {
        it('returns knoType', async function () {
          await instance.create(1001, one);
          expect(await instance.knoType(0)).to.equal(one);
        });
      });
      describe('#cancelled()', function () {
        it('returns cancelled', async function () {
          await instance.create(1001, one);
          await instance.cancel(0);
          expect(await instance.cancelled(0)).to.equal(true);
        });
      });
      describe('#deposits()', function () {
        it('returns deposits', async function () {
          const msgvalue = ethers.utils.parseUnits('1000', 0);
          await instance.create(1001, one);
          await instance.connect(addr1).deposit(zero, { value: msgvalue });
          expect(await instance.deposits(0, addr1.address)).to.equal(1000);
        });
      });
      describe('#withdrawFeeBP()', function () {
        it('returns withdrawFeeBP', async function () {
          await instance.setWithdrawFeeBP(500);
          expect(await instance.withdrawFeeBP()).to.equal(500);
        });
      });
      describe('#depositFeeBP()', function () {
        it('returns depositFeeBP', async function () {
          await instance.setDepositFeeBP(500);
          expect(await instance.depositFeeBP()).to.equal(500);
        });
      });
      describe('#feesCollected()', function () {
        it('returns feesCollected', async function () {
          const msgvalue = ethers.utils.parseUnits('1000', 0);
          await instance.create(1001, one);
          await instance.setDepositFeeBP(500);
          await instance.connect(addr1).deposit(zero, { value: msgvalue });
          expect(await instance.feesCollected()).to.equal(50);
        });
      });
    });
  });
}
