pragma solidity ^0.8.6;

contract DAOProject {
  struct Proposal {
    uint id;
    string name;
    uint amount;
    address payable recipient;
    uint votes;
    uint end;
    bool executed;
  }

  mapping(address => bool) public investors;
  mapping(address => uint) public shares;
  mapping(address => mapping(uint => bool)) public votes;
  mapping(uint => Proposal) public proposals;
  uint public totalShares;
  uint public availableFunds;
  uint public contributionEnd;
  uint public nextProposalId;
  uint public voteTime;
  uint public quorum;
  address public admin;

  constructor(
    uint contributionTime, 
    uint _voteTime,
    uint _quorum) 
    public {
    require(_quorum > 0 && _quorum < 100, 'quorum must be between 0 and 100');
    contributionEnd = now + contributionTime;
    voteTime = _voteTime;
    quorum = _quorum;
    admin = msg.sender;
  }

  function contribute() payable external {
    require(now < contributionEnd, 'cannot contribute after contribution has ended');
    investors[msg.sender] = true;
    shares[msg.sender] += msg.value;
    totalShares += msg.value;
    availableFunds += msg.value;
  }

  function redeemShare(uint amount) external {
    require(shares[msg.sender] >= amount, 'not enough shares');
    require(availableFunds >= amount, 'not enough available funds');
    shares[msg.sender] -= amount;
    availableFunds -= amount;
    msg.sender.transfer(amount);
  }
    
  function transferShare(uint amount, address to) external {
    require(shares[msg.sender] >= amount, 'not enough shares');
    shares[msg.sender] -= amount;
    shares[to] += amount;
    investors[to] = true;
  }

  function createProposal(
    string memory name,
    uint amount,
    address payable recipient) 
    public 
    onlyInvestors() {
    require(availableFunds >= amount, 'amount too big');
    proposals[nextProposalId] = Proposal(
      nextProposalId,
      name,
      amount,
      recipient,
      0,
      now + voteTime,
      false
    );
    availableFunds -= amount;
    nextProposalId++;
  }

  function voteOnProposal(uint proposalId) external onlyInvestors() {
    Proposal storage proposal = proposals[proposalId];
    require(votes[msg.sender][proposalId] == false, 'investor can only vote once for a proposal');
    require(now < proposal.end, 'can only vote until proposal end date');
    votes[msg.sender][proposalId] = true;
    proposal.votes += shares[msg.sender];
  }

  function executeProposal(uint proposalId) external onlyAdmin() {
    Proposal storage proposal = proposals[proposalId];
    require(now >= proposal.end, 'cannot execute proposal before end date');
    require(proposal.executed == false, 'cannot execute proposal already executed');
    require((proposal.votes / totalShares) * 100 >= quorum, 'cannot execute proposal with votes # below quorum');
    _transferEther(proposal.amount, proposal.recipient);
  }

  function withdrawFunds(uint amount, address payable to) external onlyAdmin() {
    _transferEther(amount, to);
  }
  
  function _transferFunds(uint amount, address payable to) internal {
    require(amount <= availableFunds, 'not enough available Funds');
    availableFunds -= amount;
    to.transfer(amount);
  }

  function() payable external {
    availableFunds += msg.value;
  }

  modifier onlyInvestors() {
    require(investors[msg.sender] == true, 'only investors');
    _;
  }

  modifier onlyAdmin() {
    require(msg.sender == admin, 'only admin');
    _;
  }
}
