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
    let KnoBlockIOInstance: MockKnoBlockIO;

    before(async function () {
      [deployer, addr1, addr2] = await ethers.getSigners();
    });

    beforeEach(async function () {
      KnoBlockIOInstance = await new MockKnoBlockIO__factory(deployer).deploy();
    });

    describe('Deployment', function () {
      it('Should set the right owner', async function () {
        await KnoBlockIOInstance.deployed();
        const owner = await KnoBlockIOInstance.MockReturnOwner();
        expect(deployer.address).to.equal(owner); 
      });
    });

    describe('Create KnoBlock', function () { 
      //Is there not a way to initiate the function once for all these checks
      it('Should increment count variable by 1', async function () {
        await KnoBlockIOInstance.deployed();
        await KnoBlockIOInstance.createKnoBlock(1001, 1);
        expect(await KnoBlockIOInstance.MockReturnCount()).to.equal(1);
      });

      it('Should add a new KnoBlock to the KnoBlock Mapping', async function () {
        await KnoBlockIOInstance.deployed();
        await KnoBlockIOInstance.createKnoBlock(1001, 1);
        expect(await KnoBlockIOInstance.JungleIsMassiv).to.equal(1);
      });

      it('new KnoBlock should have msg.sender as creator', async function () {
        await KnoBlockIOInstance.deployed();
        await KnoBlockIOInstance.createKnoBlock(1001, 1);
        expect(await KnoBlockIOInstance.MockReturnKnoBlockCreator(0)).to.equal(
          deployer.address,
        );
      });

      it('new KnoBlock should have unlockAmount set to 1001', async function () {
        await KnoBlockIOInstance.deployed();
        await KnoBlockIOInstance.createKnoBlock(1001, 1);
        expect(
          await KnoBlockIOInstance.MockReturnKnoBlockUnlockAmount(0),
        ).to.equal(1001);
      });

      it('new KnoBlock should have unlockAmount set knoType to 1', async function () {
        await KnoBlockIOInstance.deployed();
        await KnoBlockIOInstance.createKnoBlock(1001, 1);
        expect(await KnoBlockIOInstance.MockReturnKnoBlockKnoType(0)).to.equal(
          1,
        );
      });
      it('Should Emit new KnoBlock Event', async function () {
        expect(await KnoBlockIOInstance.createKnoBlock(1001, 1))
          .to.emit(KnoBlockIOInstance, 'NewKnoBlock')
          .withArgs(0, deployer.address, 1001, 0, 1);
      });
    });
  });
});
