pragma solidity ^0.8.7;

import "@openzeppelin/contracts/token/ERC20/ERC20.sol";

contract DeeCoin is ERC20 {
     constructor() ERC20("DeeCoin", "DEE") {
	_mint(mesg.sender, 1000 * 10 ** 18);
   }
}
