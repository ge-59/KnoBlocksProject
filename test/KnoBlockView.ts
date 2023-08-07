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

      describe('#count()', function () {
        it('returns count variable', async function () {
          await instance.connect(deployer).create(1001, one);
          expect(await instance.connect(deployer).count()).to.equal(one);
        });
      });
      describe('#creator()', function () {
        it('returns creator', async function () {
          await instance.connect(bob).create(1001, one);
          expect(await instance.connect(deployer).creator(0)).to.equal(
            bob.address,
          );
        });
      });
      describe('#unlockAmount()', function () {
        it('returns unlockAmount', async function () {
          await instance.connect(deployer).create(1001, one);
          expect(await instance.connect(deployer).unlockAmount(0)).to.equal(
            1001,
          );
        });
      });
      describe('#currentAmount()', function () {
        it('returns currentAmount', async function () {
          const msgvalue = ethers.utils.parseUnits('1001', 0);
          await instance.connect(deployer).create(1001, one);
          await instance.connect(deployer).deposit(zero, { value: msgvalue });
          expect(await instance.connect(deployer).currentAmount(0)).to.equal(
            1001,
          );
        });
      });
      describe('#knoType()', function () {
        it('returns knoType', async function () {
          await instance.connect(deployer).create(1001, one);
          expect(await instance.connect(deployer).knoType(0)).to.equal(one);
        });
      });
      describe('#cancelled()', function () {
        it('returns cancelled', async function () {
          await instance.connect(deployer).create(1001, one);
          await instance.connect(deployer).cancel(0);
          expect(await instance.connect(deployer).cancelled(0)).to.equal(true);
        });
      });
      describe('#deposits()', function () {
        it('returns deposits', async function () {
          const msgvalue = ethers.utils.parseUnits('1000', 0);
          await instance.connect(deployer).create(1001, one);
          await instance.connect(bob).deposit(zero, { value: msgvalue });
          expect(
            await instance.connect(deployer).deposits(0, bob.address),
          ).to.equal(1000);
        });
      });
      describe('#withdrawFeeBP()', function () {
        it('returns withdrawFeeBP', async function () {
          await instance.connect(deployer).setWithdrawFeeBP(500);
          expect(await instance.connect(deployer).withdrawFeeBP()).to.equal(
            500,
          );
        });
      });
      describe('#depositFeeBP()', function () {
        it('returns depositFeeBP', async function () {
          await instance.connect(deployer).setDepositFeeBP(500);
          expect(await instance.connect(deployer).depositFeeBP()).to.equal(500);
        });
      });
      describe('#feesCollected()', function () {
        it('returns feesCollected', async function () {
          const msgvalue = ethers.utils.parseUnits('1000', 0);
          await instance.connect(deployer).create(1001, one);
          await instance.connect(deployer).setDepositFeeBP(500);
          await instance.connect(bob).deposit(zero, { value: msgvalue });
          expect(await instance.connect(deployer).feesCollected()).to.equal(50);
        });
      });
    });
  });
}
