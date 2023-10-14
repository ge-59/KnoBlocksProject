import { ethers } from 'hardhat';
import { SignerWithAddress } from '@nomiclabs/hardhat-ethers/signers';
import {
  KnoBlockDiamond,
  KnoBlockDiamond__factory,
  KnoBlockAdmin__factory,
  KnoBlockIO__factory,
  KnoBlockView__factory,
} from '../typechain-types';

async function main() {
  let deployer: SignerWithAddress;

  let diamond: KnoBlockDiamond;
  [deployer] = await ethers.getSigners();

  console.log(
    `Deploying contracts with the deployer account: ${deployer.address}`,
  );

  diamond = await new KnoBlockDiamond__factory(deployer).deploy(125, 125);

  console.log('KnoBlockDiamond deployed to:', diamond.address);

  const facetFactories = [
    KnoBlockAdmin__factory,
    KnoBlockIO__factory,
    KnoBlockView__factory,
  ];

  const facetCuts = [];

  for (const factory of facetFactories) {
    const facetFactory = new factory(deployer);
    const facet = await facetFactory.deploy();
    await facet.deployed();
    const selectors = Object.keys(facet.interface.functions).map((fn) =>
      facet.interface.getSighash(fn),
    );
    facetCuts.push({
      target: facet.address,
      action: 0,
      selectors,
    });
  }

  await diamond.diamondCut(facetCuts, ethers.constants.AddressZero, '0x');
  console.log('Facets added to the Diamond.');

  console.log('Deployment complete.');
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error(error);
    process.exit(1);
  });
