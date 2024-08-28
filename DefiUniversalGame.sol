// SPDX-License-Identifier: MIT
pragma solidity 0.8.22;

import "./ERC20.sol";
import "./Vault.sol";
contract DefiUniversalGame{

    address public manager;
    address[] public players;
    uint public lotteryEndTime;
    uint public ticketPrice;
    bool public lotteryClosed;
    address public winner;

    ERC20 tokenInstance;
    Bank bank;

    constructor(){
        tokenInstance = new ERC20("DEFIUNIVERSE","DUE");
        bank = new Bank(address(tokenInstance));
         manager = msg.sender;
    }

 

    function depositInBankbank(uint _tokenAmount) external{
      require(tokenInstance.balanceOf(msg.sender)>=_tokenAmount);
      tokenInstance.transferFunc(msg.sender, address(bank), _tokenAmount);
        bank.depositTokens(msg.sender, _tokenAmount);
        
    }
    function withdrawFromBank() external{
     
      uint depositedAmount =  bank.withdrawTokens(msg.sender);
      uint interest = depositedAmount * 10/100;
      tokenInstance.mintTokens(msg.sender, depositedAmount + interest);
    }

    function getBankBalance()external view returns(uint){
        return bank.bankBalance(msg.sender);
    }

    // pseudo functions

    function tranferToOther(address _address,uint _amount)external {
        require(tokenInstance.balanceOf(msg.sender)>=_amount);
        bank.transferFunc(msg.sender,_address,_amount);
    }




    function mint(uint _tokenAmount) external {
        tokenInstance.mintTokens(msg.sender, _tokenAmount);
    }



    function checkBalance() public view returns(uint){ 
        return tokenInstance.balanceOf(msg.sender);
    }

     function machineRandomNumber() internal view returns(uint) {
        uint val = uint256(keccak256(abi.encodePacked(block.timestamp, block.coinbase, block.difficulty,address(this))));
        return val;
    }

    function burnTokens(uint _tokenAmount) public {
        require(tokenInstance.balanceOf(msg.sender)>=_tokenAmount);
        tokenInstance._burn(msg.sender,_tokenAmount);
    }


    function startLottery(uint _durationMin, uint _ticketWei) external{
        lotteryEndTime = block.timestamp + (_durationMin * 1 minutes);
        ticketPrice = _ticketWei;
        lotteryClosed = false;
    }


    function buyLotteryTicket() public payable {
        require(msg.value >= ticketPrice, "Not Enought Wei for Lottery Ticket");
        uint extraBalance = msg.value - ticketPrice;
        (bool response,) = payable (msg.sender).call{value:extraBalance}(""
        );
        require(response,"Can't return the extra amount");
        require(block.timestamp < lotteryEndTime, "Lottery is already ended.");
        require(!lotteryClosed, "Lottery is closed.");
        players.push(msg.sender);
    }

    function pickWinner() public onlyManager {
        require(block.timestamp >= lotteryEndTime, "Lottery is still running.");
        require(players.length > 0, "No players in the lottery.");
        require(!lotteryClosed, "Winner has already been picked.");

        uint winnerIndex = machineRandomNumber() % players.length;
         winner = players[winnerIndex];

        tokenInstance.mintTokens(winner, 10000);
        lotteryClosed = true;
    }


    modifier onlyManager() {
        require(msg.sender == manager, "Only the manager can call this function.");
        _;
    }


    function getPlayers() public view returns (address[] memory) {
        return players;
    }


    function timeLeft() public view returns (uint) {
        if (block.timestamp >= lotteryEndTime) {
            return 0;
        } else {
            return lotteryEndTime - block.timestamp;
        }
    }

}