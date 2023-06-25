//SPDX-License-Identifier: MIT 
pragma solidity ^0.8.18;
import "@chainlink/contracts/src/v0.8/interfaces/VRFCoordinatorV2Interface.sol";
import "@chainlink/contracts/src/v0.8/VRFConsumerBaseV2.sol";

error Lottery_NotEnoughETHEntered();
error Lottery_TransferFailed();
contract Lottery is VRFConsumerBaseV2{
    uint256 private immutable i_entranceFee;
    address payable[] private s_players;
    
     VRFCoordinatorV2Interface private immutable i_vrfCoordinator;
      bytes32 private  immutable i_gasLane;
       uint64 private immutable i_subscriptionId;
       uint32 private immutable i_callbackGasLimit;
       uint16 private constant REQUEST_CONFIRMATIONS = 3;
       uint32 private constant NUM_WORDS = 1;

       //Lottery Variables
       address private s_recentWinner;

// Events
event Lotteryenter(address indexed player);
event RequestedLotteryWinner(uint256 indexed requestId);
event WinnerPicked(address indexed winner);
    constructor(address vrfCoordinatorV2 ,
    uint256 entranceFee,
    bytes32 i_gasLane,
    uint64 i_subscriptionId,
    uint32 callbackGasLimit) 
    VRFConsumerBaseV2(vrfCoordinator){
        i_entranceFee = i_entranceFee;
        i_vrfCoordinator = VRFCoordinatorV2Interface(vrfCoordinatorV2);
        i_gasLane = gasLane;
        i_subscriptionId = subscriptionId;
        i_callbackGasLimit = callbackGasLimit;
    }

function enterLottery() public payable{
if(msg.value < i_entranceFee){
    revert Lottery_NotEnoughETHEntered();
}
s_players.push(payable(msg.sender));
emit Lotteryenter(msg.sender);
}

function requestRandomWords() external returns (uint256 requestId){
   requestId = i_vrfCoordinator.requestRandomWords(
            i_gasLane,
            i_subscriptionId,
            REQUEST_CONFIRMATIONS,
            i_callbackGasLimit,
            NUM_WORDS
        );
        emit RequestedLotteryWinner(requestId);
}

function fullfillRandomWords(uint256 requestId,uint256[] memory randomWords) internal override{
    uint256 indexOfRandomWinner = randomWords % s_players.length;
    address payable recentWinner = s_players[indexOfRandomWinner];
    s_recentWinner = recentWinner;
    (bool success,) = recentWinner.call{value: address(this).balance}(""); 
    if(!success){
        revert LotteryTranserFailed();
    }
    emit WinnerPicked(recentWinner);
    }

function getEntranceFee()public view returns(uint256){
    return i_entranceFee;
}
fucntion getPlayer(uint256 index) public view returns(address){
    retrun s_players[index];
}
function getRecentWinner() public view returns(address){
    return s_recentWinner;
}

}