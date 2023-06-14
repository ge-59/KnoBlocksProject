import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import { MockKnoBlockIO, MockKnoBlockIO__factory } from '../typechain-types';
import { ethers } from 'hardhat';
import { BigNumber, ContractTransaction } from 'ethers';
import { expect } from 'chai';

describe('KnoBlockAdmin contract', function () {
  describe('KnoBlockAdmin', function () {
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

    describe('#ownerSet()', function () {
      it('sets the right owner', async function () {
        await instance.setOwner(addr1.address);
        expect(await instance.owned()).to.equal(addr1.address);
      });
    });
    describe('#setWithdrawFee()', function () {
      it('sets the withdraw fee', async function () {
        await instance.setWithdrawFee(1000);
        expect(await instance.withdrawFees()).to.equal(1000);
      });
    });
    describe('#setDepositFee()', function () {
      it('sets the deposit fee', async function () {
        await instance.setDepositFee(1000);
        expect(await instance.depositFees()).to.equal(1000);
      });
    });
    describe('#withdrawBalance()', function () {
      it('withdraws contract balance', async function () {
        const msgvalue = {
          value: ethers.utils.parseEther('0.000000000000001001'),
        }; //sending 1001 wei
        await instance.connect(addr1).create(1001, one);
        await instance.connect(addr1).deposit(zero, msgvalue);
        expect(instance.withdrawBalance).to.changeEtherBalance(
          deployer,
          msgvalue,
        );
      });
    });
  });
});
