// SPDX-License-Identifier: GPL-3.0

pragma solidity ^0.8.9; 


contract lotteryContract {
    /**

    we are creating a lottery smart contract, so what do we require?

    a. state variables - owner and players
    b. modifier to determoine only owner and whether owner can participate in the lottery or not
    c. function to enter the lottery
    d. function to determine the source of randomness
    e. this function should take the keccak function to ensure transfer of token to the winner


    */

    address payable[] public lotteryPlayers;
    address public lotteryManager;
    mapping (address => uint) public lotteryBalance;
    
    

    constructor() {
        lotteryManager = msg.sender;

    }

    receive() external payable {}
    fallback() external payable {}

    modifier onlyManager() {
        require(msg.sender == lotteryManager, "Only Manager can carry out this Function");
        _;
    }
    

    modifier notManager() {
        require(msg.sender != lotteryManager, "Manager cannot participate in Lottery");
        _;
    }

    modifier lotteryAmount() {
        require(msg.value >= 0.2 ether, "Insufficient Entry Amount");
        _;
    }
    modifier _noOfLotteryPlayers() {
        require(lotteryPlayers.length >= 5, "Players not up to 5");
        _;
    }

    function enterLottery() public payable notManager lotteryAmount returns (uint){
        lotteryPlayers.push(payable(msg.sender));
       return lotteryBalance[msg.sender] += msg.value;

    }

    function randomLottery () internal view returns (uint) {
        return uint(keccak256(abi.encodePacked(block.difficulty, block.timestamp, lotteryPlayers.length)));

    }

    function lotteryWinner() public onlyManager _noOfLotteryPlayers {
        uint randomLotteryPicks = randomLottery();
        address payable lotteryRoundWinner;
        uint index = randomLotteryPicks % lotteryPlayers.length;
        lotteryRoundWinner = lotteryPlayers[index];
       lotteryRoundWinner.transfer(getBalance());
         lotteryPlayers = new address payable[](0);



    }

    function getBalance() public view returns(uint) {
        return address(this).balance;

    }





}