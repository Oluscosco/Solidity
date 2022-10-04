pragma solidity ^0.6.11;

contract MyEventContract{
  uint a;

  event NewEvent(
    uint indexed date,
    address indexed from,
    address indexed to, 
    uint amount 
  );

   function TradeEvent(address to, uint amount) extranal{
     emit NewEvent(now, msg.sender, to, amount);
 }
}
