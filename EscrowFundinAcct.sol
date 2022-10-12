pragma solidity ^0.8.6;

contract EscrowFundinAcct{
  address public payer;
  address payable public payee;
  address public advocate;
  uint public amount;
  
  constructor(
    address _payer, 
    address payable _payee, 
    uint _amount) 
    public {
    payer = _payer;
    payee = _payee;
    lawyer = msg.sender; 
    amount = _amount;
  }

  function depositFunds() payable public {
    require(msg.sender = payer, 'Sender must be the payer of funds');
    require(address(this).balance <= amount, 'Cant send funds more than escrow amount');
  }

  function releaseFunds() public {
    require(address(this).balance == amount, 'cannot release funds before full amount is sent');
    require(msg.sender == advocate, 'only Authrized Advocate can release funds');
    payee.transfer(amount);
  }
  
  function balanceOfFunds() view public returns(uint) {
    return address(this).balance;
  }
}
