const { expect } = require("chai");
const { ethers } = require("hardhat");


describe("Card Sale test", function() {
    let owner, customer;
    let GameCoin, gameCoin, CardPack, cardPack, CardPackSale, cardPackSale;
    let cardPackTypes, cardPackPrices;
    beforeEach(async () => {
        [owner, customer] = await ethers.getSigners();
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

        cardPackTypes = {
            COMMON: 0,
            EPIC: 1,
            LEGENDARY: 2
        }
        cardPackPrices = {
            COMMON: 10,
            EPIC: 100,
            LEGENDARY: 500
        }
        
    });
    it("buy test", async function() {
        await expect(cardPackSale.connect(customer).buyCardPack(cardPackTypes.COMMON)).to.be.reverted;
        await gameCoin.transfer(customer.address, 2000);
        await expect(cardPackSale.connect(customer).buyCardPack(cardPackTypes.COMMON)).to.be.reverted;
        await gameCoin.connect(customer).increaseAllowance(cardPackSale.address, cardPackPrices.COMMON);

        await expect(cardPackSale.connect(customer).buyCardPack(4)).to.be.reverted;
        let oldOwnerBalance = await gameCoin.balanceOf(owner.address);
        await cardPackSale.connect(customer).buyCardPack(cardPackTypes.COMMON);
        expect(await gameCoin.balanceOf(customer.address)).to.equal(2000 - cardPackPrices.COMMON);
        expect(await cardPack.balanceOf(customer.address, cardPackTypes.COMMON)).to.equal(1);
        expect(await gameCoin.balanceOf(owner.address)).to.equal(BigInt(oldOwnerBalance) + BigInt(cardPackPrices.COMMON));
    });

    describe("open pack test", function() {
        let CardPackOpening, cardPackOpening, Card, card;
        beforeEach(async () => {
            await gameCoin.transfer(customer.address, 1000);
            await gameCoin.connect(customer).increaseAllowance(cardPackSale.address, 1000);
            await cardPackSale.connect(customer).buyCardPack(cardPackTypes.EPIC);

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
        });
        it("open", async function() {
            for (i = 1; i < 101; i++) {
                console.log(await cardPack.getCardByDistribution(2, i));
            }
        });
    });
});