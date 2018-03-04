pragma solidity ^0.4.18;

import "./crowdsale.sol";
import "./SafeMath.sol";

contract DAICO is Crowdsale {


  using SafeMath for uint256;

  uint256 public openingTime;
  uint256 public closingTime;
  uint256 public TapSet;
  uint256 public lastWithdrawn;

  /* The length the funds are held in the contract till the full amount is 
     ditributed to the team(in seconds)
  */
  uint256 public tapPeriod;

  //Tap Rate at which developers can withdraw funds(wei/sec)
  uint256 public tap;
  uint256 public TotalYesVotes;
  uint256 public TotalNoVotes;
  uint256 public startVoting;
  uint256 public endVoting;

  bytes32 public proposal;
  bool public ongoingProposal;
  mapping (address => bool) VoteCast;

  event TapRaise(address,uint256,uint256,string);
  event Destruct();


  modifier onlyWhileOpen {
    require(now >= openingTime && now <= closingTime);
    _;
  }

  modifier setTap {
   require(TapSet == 0);
   _;
   TapSet += 1;
  }

  modifier onlyWhileClosed {
      require(now >= closingTime);
      _;   
  }

  modifier onlyOwner {
      require(msg.sender == wallet);
      _;
  }

//TODO : Add a modifier function for during and after voting to make code cleaner  

// Setting Up Constructor Function

  function DAICO(uint256 _openingTime, uint256 _closingTime, uint256 _tapPeriod) public {
    require(_openingTime >= now);
    require(_closingTime >= _openingTime);
    require(_tapPeriod >= 2);

    tapPeriod = _tapPeriod.mul(31536000);
    lastWithdrawn = _closingTime;
    openingTime = _openingTime;
    closingTime = _closingTime;

  }

  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
    super._preValidatePurchase(_beneficiary, _weiAmount);
    
  }

  function _hasClosed() public view returns (bool) {
    return now > closingTime;
  }

// Setting the Tap
  function _setTap() onlyOwner onlyWhileClosed setTap {
      tap = this.balance.div(tapPeriod);
  }

// The withdraw function for the devs
  function _withdraw() onlyOwner onlyWhileClosed {
      require(TapSet > 0);
      uint256 amount = tap.mul(block.timestamp.sub(lastWithdrawn));
      lastWithdrawn = block.timestamp;
      wallet.transfer(amount);

  }

// Allow Owner to Modify Tap
  function _ownerModifyTap(uint256 _tap) onlyOwner {
      require(TapSet > 0);
      require(tap > _tap);
      tap = _tap;
   
  }
//TODO: do not allow proposals while crowdsale is still running 

// Proposal to raise Tap 
  function _setRaiseProposal() {
      require(ongoingProposal == false);
      ongoingProposal = true;
      startVoting = block.timestamp;
      endVoting = startVoting.add(1209600);
      proposal = "Raise";
      TapRaise(msg.sender,startVoting,endVoting,"Vote To Raise Tap");   

  }

// Proposal to destroy the DAICO
  function _setDestructProposal() {
      require(ongoingProposal == false);
      ongoingProposal = true;
      startVoting = block.timestamp;
      endVoting = startVoting.add(1209600);
      proposal = "Destruct";
      TapRaise(msg.sender,startVoting,endVoting,"Vote To destruct DAICO and return funds");  

  }

// Casting a Yes Vote for Voting
  function _castYesVote() internal {
      require(ongoingProposal == true);
      require(endVoting > block.timestamp);
      require(token.balanceOf(msg.sender) > 0);
      require(VoteCast[msg.sender] == false);
      VoteCast[msg.sender] == true;
      TotalYesVotes.add(1);

  }

// Casting a No Vote  
  function _castNoVote() internal {
      require(ongoingProposal == true);
      require(endVoting > block.timestamp);
      require(token.balanceOf(msg.sender) > 0);
      require(VoteCast[msg.sender] == false);
      VoteCast[msg.sender] == true;
      TotalNoVotes.add(1);

  }

// Tallying all the votes to take a decision
  function _voteTallying() public {
      require(ongoingProposal == true);
      require(endVoting < block.timestamp);
      if (proposal == "Raise") {
          if (TotalYesVotes > TotalNoVotes) {
                require(TapSet > 0);
                require(tap > _tap);
                tap = _tap;

          }

      }
  }
  function _returnFunds() internal {
     
  }
  function _raiseTap() internal {

  }
  

  



}

