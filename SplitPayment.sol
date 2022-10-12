pragma solidity ^0.8.6;

contract SplitPayment {
  address owner;
  
  constructor(address _owner) public  {
      owner = _owner; 
  }
  
  function send(address payable[] memory to, uint[] memory amount ) 
    payable 
    public 
    ownerOnly {
    require(to.length == amount.length, 'Amount to split must be same length as amount');
    for(uint i = 0; i < to.length; i++) {
      to[i].transfer(amount[i]);
    }
  }
  
  modifier ownerOnly() {
    require(msg.sender == owner);
    _;
  }
}
