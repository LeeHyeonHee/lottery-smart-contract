const Lottery = artifacts.require("Lottery");
const assertRevert = require('./assertRevert');

contract('Lottery', function([deployer, user1, user2]){
    let lottery;
    beforeEach(async () => {
        console.log('Before each');
        lottery = await Lottery.new();
    })
    // it('Basic test', async () => {
    //     console.log('Basic test');
    //     let owner = await lottery.owner();

    //     console.log(`owner : ${owner}`);
    //     console.log(`value : ${value}`);
    //     assert.equal(value, 5)
    // }) 
    it('getPot should return current pot', async () => {   // it.only하면 해당 함수만 실행
        let pot = await lottery.getPot();
        assert.equal(pot, 0)
    })

    describe('Bet', function() {
        it.only('should fail when the bet money is not 0.005 ETH', async() => {
            // Fail transaction
            await assertRevert(lottery.bet('0xab', {from : user1, value: 4000000000000000}))
            // transaction object {chainId, value, to, from, gas(Limit), gasPrice}
        })
        it('should put the bet to the bet queue with 1 bet', async() => {
            //bet
            await lottery.bet('0xab', {from : user1, value: 5000000000000000})
            // check contract balance == 0.005

            // check bet info

            // check log

        })
    })
});