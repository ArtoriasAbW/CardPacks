async function main() {
    await testDeployed(
        '0x43D0Ba4C92334939d434887D83cE35B4c8BEb50b',
        '0x74dbFd6fE6D396B2b0421D8a94CCb212fa081EB4',
        '0x09b2F7631F29527eb0f4422decf971A102660a99',
        '0xAd2EE95991824E660163637ADCA97475cF66F823',
        '0x81dB294437A031b2dF7Ff2628068757E17aC60CF'
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

    // await gameCoin.increaseAllowance(cardPackSale.address, 500);
    // await cardPackSale.buyCardPack(2);
    // console.log(await cardPack.balanceOf(account, 2));
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
    // const options = {value: ethers.utils.parseEther("0.01")};
    // await cardPackOpening.openCardPack(2, options);
}
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
