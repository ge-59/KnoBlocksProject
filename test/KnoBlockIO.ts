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
      // Does not set the "owner" in KnoBlock Storage, but in Ownable. So do we even need the one in KnoBlockStorage?
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
    describe('KnoBlock Deposit', function () {
      it('Should Increase the KnoBlocks currentAmount by msg.value', async function () {
        const msgvalue = { value: ethers.utils.parseEther('0.000000000000001') }; //sending 1000 wei 
        await KnoBlockIOInstance.deployed();
        await KnoBlockIOInstance.createKnoBlock(1001, 1);
        await KnoBlockIOInstance.knoDeposit(0, msgvalue);
      expect(
        await KnoBlockIOInstance.MockReturnKnoBlockCurrentAmount(0),
      ).to.equal(1000);
  });
 it('Should update msg.senders deposit value accurately', async function () {
  const msgvalue = { value: ethers.utils.parseEther('0.000000000000001') };  //sending 1000 wei 
  await KnoBlockIOInstance.deployed();
  await KnoBlockIOInstance.createKnoBlock(1001, 1);
  await KnoBlockIOInstance.knoDeposit(0, msgvalue);
expect(
  await KnoBlockIOInstance.MockReturnKnoBlockDeposits(0),
).to.equal(1000);
});

it('Unlocked variable of Knoblock should be set to true if currentAmount is equal to UnlockAmount', async function () {
  const msgvalue = { value: ethers.utils.parseEther('0.000000000000001001') };  //sending 1001 wei 
  await KnoBlockIOInstance.deployed();
  await KnoBlockIOInstance.createKnoBlock(1001, 1);
  await KnoBlockIOInstance.knoDeposit(0, msgvalue);
expect(
  await KnoBlockIOInstance.MockReturnKnoBlockDeposits(0),
).to.equal(1001);  // is there any value in keeping this? 
expect(
  await KnoBlockIOInstance.MockReturnKnoBlockUnlocked(0),
).to.be.true;
});

it('Unlocked Event should be emitted if currentAmount is equal to UnlockAmount', async function () {
  const msgvalue = { value: ethers.utils.parseEther('0.000000000000001001') };  //sending 1001 wei 
  await KnoBlockIOInstance.deployed();
  await KnoBlockIOInstance.createKnoBlock(1001, 1);
  expect(await KnoBlockIOInstance.knoDeposit(0, msgvalue))
          .to.emit(KnoBlockIOInstance, 'BlockUnlocked')
          .withArgs(0, deployer.address, 1001, 1001, 1);

});

it('Unlocked variable of Knoblock should be set to true if currentAmount is greater to UnlockAmount', async function () {
  const msgvalue = { value: ethers.utils.parseEther('0.000000000000002000') };  //sending 2000 wei
  await KnoBlockIOInstance.deployed();
  await KnoBlockIOInstance.createKnoBlock(1001, 1);
  await KnoBlockIOInstance.knoDeposit(0, msgvalue);
expect(
  await KnoBlockIOInstance.MockReturnKnoBlockUnlocked(0),
).to.be.true;
});

it('Unlocked Event should be emitted if currentAmount is equal to UnlockAmount', async function () {
  const msgvalue = { value: ethers.utils.parseEther('0.000000000000002000') };  //sending 2000 wei
  await KnoBlockIOInstance.deployed();
  await KnoBlockIOInstance.createKnoBlock(1001, 1);
  expect(await KnoBlockIOInstance.knoDeposit(0, msgvalue))
          .to.emit(KnoBlockIOInstance, 'BlockUnlocked')
          .withArgs(0, deployer.address, 1001, 1001, 1);

});

it('Should return Overkill to Msg.sender if they deposit more than the remaining amount to Unlock', async function () {
  const msgvalue = { value: ethers.utils.parseEther('0.000000000000002000') };  //sending 2000 wei
  await KnoBlockIOInstance.deployed();
  await KnoBlockIOInstance.createKnoBlock(1001, 1);
  await KnoBlockIOInstance.knoDeposit(0, msgvalue);
expect //not todei
});
  
 // Sadge //
  it('HUH.Cant set a KnoBlocks Value in Ethers', async function () {
    const msgvalue = { value: ethers.utils.parseEther('0.000000000000001') }; 
    await KnoBlockIOInstance.deployed();
    await KnoBlockIOInstance.createKnoBlock(1000000000000000000, 1);   
    await KnoBlockIOInstance.knoDeposit(0, msgvalue);
  expect(
    await KnoBlockIOInstance.MockReturnKnoBlockCurrentAmount(0),
  ).to.equal(1000);
});
    });
  });
});


