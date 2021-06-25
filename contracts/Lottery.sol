pragma solidity >=0.4.21 <0.6.0;

contract Lottery {
    struct BetInfo {
        uint256 answerBlockNumber;
        address payable bettor;
        byte challenges; 
    }


    uint256 private _tail;
    uint256 private _head;
    mapping (uint256 => BetInfo) private _bets;
    address public owner;

    uint256 constant internal BLOCK_LIMIT = 256;
    uint256 constant internal BET_BLOCK_INTERVAL = 3;
    uint256 constant internal BET_AMOUNT = 5 * 10 ** 15;
    uint256 private _pot;

    event BET(uint256 index, address bettor, uint256 amount, byte challenges, uint256 answerBlockNumber);

    constructor() public {
        owner = msg.sender;
    }

    function getPot() public view returns (uint256 pot) {  //smart contract 안의 변수를 확인하는 함수엔 view가 들어가야함 
        return _pot;
    }

    // Bet
    /**
     * @dev   배팅을 한다. 유저는 0.005ETH를 보내야하고 배팅용 1byte 글자를 보낸다.
     *  큐에 저장되는 베팅 정보는 이후 distribute함수에서 해결된다.
     * @param challenges 유저가 베팅하는 글자 
     * @return 함수가 잘 수행되었는지 확인하는 bool 값 
     */
    function bet(byte challenges) public payable returns (bool result) { //payable은 invoke 처럼 돈보낼때 붙여줘야만 저장되는 역할 
        // Check the proper ether is sent
        require(msg.value == BET_AMOUNT, "Not enough ETH");
        // Push bet to the queue
        require(pushBet(challenges), "Fail to add a new Bet Info");
        // emit event
        emit BET(_tail - 1, msg.sender, msg.value, challenges, block.number + BET_BLOCK_INTERVAL);    
        return true;
    }
        // saver the bet to the queue

    // Distribute
        // check the answer
    

    function getBetInfo(uint256 index) public view returns (uint256 answerBlockNumber, address bettor, byte challenges) {
        BetInfo memory b = _bets[index];
        answerBlockNumber = b.answerBlockNumber;
        bettor = b.bettor; 
        challenges = b.challenges;
    }

    function pushBet(byte challenges) internal returns (bool) {  //internal 은 내부함수 .. java의 private 개념
        BetInfo memory b;
        b.bettor = msg.sender;
        b.answerBlockNumber = block.number + BET_BLOCK_INTERVAL;
        b.challenges = challenges;

        _bets[_tail] = b;
        _tail++;
        return true;
    }

    function popBet(uint256 index) internal returns (bool) {
        delete _bets[index];
        return true;
    }
}