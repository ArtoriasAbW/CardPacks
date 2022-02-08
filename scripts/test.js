async function main() {
    await testDeployed(
        '0xf33CBa8da814d05e5c912D7fDBdEd7F9A1BF01d7',
        '0x3D261e37cB04f8118c104946da3f5968762c3c49',
        '0xC1EaF7a09e715AEAC6ff482c55E840db87BCCc30',
        '0xB4Bc9D64d16B8E1eA6e25eFdDB4e98f11cDd6F3d',
        '0x658CeF3c1eb42587bdaf36770667cE13314C5dE1'
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
    // console.log(await cardPack.balanceOf(account, 1));
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
    // const options = {value: ethers.utils.parseEther("0.05")};
    // await cardPackOpening.openCardPack(1, options);
}
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
