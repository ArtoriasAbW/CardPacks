async function main() {
    await testDeployed(
        '0x38c378A5A68a8B2f0828CC27e88B712A4610572f',
        '0x48c56950d0dE8614cFBd73FdcEF27AA25899816A',
        '0x500518b560eCB0F2B529c94986b021Eb0c18A758',
        '0x59Eb8ffcE73D9B39b14237f220135e33aDe7000a',
        '0xF6adcFD260DF15B1014ed1249b54AA5f74E138BB'
    );
}

async function testDeployed(gameCoinAddr, cardPackAddr, cardPackSaleAddr, cardPackOpeningAddr, CardAddr) {
    let [account] = await ethers.provider.listAccounts();
    console.log(account);
    let GameCoin = await ethers.getContractFactory("GameCoin");
    let CardPack = await ethers.getContractFactory("CardPack");
    let CardPackSale = await ethers.getContractFactory("CardPackSale");
    let CardPackOpening = await ethers.getContractFactory("CardPackOpening");
    let Card = await ethers.getContractFactory("Card");

    let gameCoin = await GameCoin.attach(gameCoinAddr);
    let cardPack = await CardPack.attach(cardPackAddr);
    let cardPackSale = await CardPackSale.attach(cardPackSaleAddr);
    let cardPackOpening = await CardPackOpening.attach(cardPackOpeningAddr);
    let card = await Card.attach(CardAddr);


    // await gameCoin.increaseAllowance(cardPackSale.address, 100);
    // await cardPackSale.buyCardPack(1);
    console.log(await cardPack.balanceOf(account, 1));
    console.log(await card.balanceOf(account, 1));
    console.log(await card.balanceOf(account, 2));
    console.log(await card.balanceOf(account, 3));
    console.log(await card.balanceOf(account, 4));
    console.log(await card.balanceOf(account, 5));
    console.log(await card.balanceOf(account, 6));
    console.log(await card.balanceOf(account, 7));
    console.log(await card.balanceOf(account, 8));
    console.log(await card.balanceOf(account, 9));
    console.log(await card.balanceOf(account, 10));
    // await cardPackOpening.openCardPack(1);
}
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
