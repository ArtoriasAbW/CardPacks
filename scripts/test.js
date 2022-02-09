async function main() {
    await testDeployed(
        '0xfE4e6f910007e3A4c67DbE668De3e2AD28f47DEB',
        '0x4BbE24158eaFbD7e70e3081DcEeE3f7B87D913FF',
        '0x6EadB52237B02b072919ec4E42Db6FC58cCCfB72',
        '0x4b39B6E5aA70a20BbB6FC956bAD363dEFCE348A2',
        '0x538c56cCbDcBBefc759BA2E56aB98F33f45a1A17'
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
    // const options = {value: ethers.utils.parseEther("0.03")};
    // await cardPackOpening.openCardPack(2, options);
}
  
  main()
    .then(() => process.exit(0))
    .catch((error) => {
      console.error(error);
      process.exit(1);
    });
