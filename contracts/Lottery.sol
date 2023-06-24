//SPDX-License-Identifier: MIT 

pragma solidity ^0.8.18;

error Lottery_NotEnoughETHEntered();
contract Lottery {
    uint256 private immutable i_entranceFee;
    address payable[] private s_players;
    constructor(uint256 entranceFee){
        i_entranceFee = i_entranceFee;
    }

function enterLottery() public payable{
if(msg.value < i_entranceFee){
    revert Lottery_NotEnoughETHEntered();
}
s_players.push(payable(msg.sender));
}



// function pickRandomWinner(){}

function getEntranceFee()public view returns(uint256){
    return i_entranceFee;
}
fucntion getPlayer(uint256 index) public view returns(address){
    retrun s_players[index];
}

}