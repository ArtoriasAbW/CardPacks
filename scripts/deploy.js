async function main() {
    const [deployer] = await ethers.getSigners();
    console.log("Deploying contracts with the account:", deployer.address);

    GameCoin = await ethers.getContractFactory("GameCoin");
    gameCoin = await GameCoin.deploy();
    await gameCoin.deployed();

    CardPack = await ethers.getContractFactory("CardPack");
    cardPack = await CardPack.deploy();
    await cardPack.deployed();

    CardPackSale = await ethers.getContractFactory("CardPackSale");
    cardPackSale = await CardPackSale.deploy();
    await cardPackSale.deployed();

    await cardPack.addManipulator(cardPackSale.address);
    await cardPackSale.setGameCoin(gameCoin.address);
    await cardPackSale.setCardPack(cardPack.address);

    CardPackOpening = await ethers.getContractFactory("CardPackOpening");
    cardPackOpening = await CardPackOpening.deploy();
    await cardPackOpening.deployed();

    await cardPackOpening.setCardPack(cardPack.address);
    await cardPack.addManipulator(cardPackOpening.address);
    
    Card = await ethers.getContractFactory("Card");
    card = await Card.deploy();
    await card.deployed();

    await card.addManipulator(cardPackOpening.address);
    await cardPackOpening.setCard(card.address);

  
    console.log("GameCoin address:", gameCoin.address);
    console.log("CardPack address:", cardPack.address);
    console.log("CardPackSale address:", cardPackSale.address);
    console.log("cardPackOpening address:", cardPackOpening.address);
    console.log("Card address:", card.address);
  }
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });


//     Solidity compilation finished successfully
// Deploying contracts with the account: 0x02D1b64aFaf68FdF2D8d7A13dD162fe9ad062a45
// GameCoin address: 0xacF5EB3eCa0A99372f647eb4e7984B69f767E3dE
// CardPack address: 0xEFEEa8675593C03d5b5E928e9c6F28552e45510A
// CardPackSale address: 0x66dE222b87354f2dd0c22307d7F2D9b2E05D50e2
// cardPackOpening address: 0x3E8545ceE3F606B15244bA2704A71296Aae6D606
// Card address: 0x839E0ec2198a5DDDAb794bd20379CBc07488e433