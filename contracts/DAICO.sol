pragma solidity ^0.4.18;

import "./Crowdsale/TimedCrowdsale.sol";
import "./Math/SafeMath.sol";
import "./Voter.sol";

contract DAICO is TimedCrowdsale, Voter {


  using SafeMath for uint256;


  uint256 public TapSet;
  uint256 public lastWithdrawn;

  /* The length the funds are held in the contract till the full amount is 
     ditributed to the team(in seconds)
  */
  uint256 public tapPeriod;

  //Tap Rate at which developers can withdraw funds(wei/sec)
  uint256 public tap;
  uint256 public tempTap;
  bool public investorWithdraw;

  mapping (address => bool) withdrawn;



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


  modifier isValidTokenHolder {
      require(token.balanceOf(msg.sender) > 0);
      require(VoteCast[proposalNumber][msg.sender] == false);
      _;
  }

  modifier contractIsinactive {
      require(investorWithdraw);
      _;
  }
  

//TODO : Add a modifier function for during and after voting to make code cleaner  

// Setting Up Constructor Function

  function DAICO(uint256 _tapPeriod) public {
    require(_tapPeriod >= 2);

    tapPeriod = _tapPeriod.mul(31536000);
    lastWithdrawn = closingTime;
  }


// Setting the Tap
  function _setTap() onlyOwner onlyWhileClosed setTap {
      tap = this.balance.div(tapPeriod);
  }

// The withdraw function for the devs
  function _withdraw() public onlyOwner onlyWhileClosed {

      require(TapSet == 1);
      uint256 amount = tap.mul(block.timestamp.sub(lastWithdrawn));
      lastWithdrawn = block.timestamp;
      wallet.transfer(amount);

  }

// Allow Owner to Modify Tap
  function _ownerModifyTap(uint256 _tap) public onlyOwner {
      require(TapSet == 1);
      require(tap > _tap);
      tap = _tap;
   
  }

//TODO: Add relevant asserts for diff proposals

//TODO: Find a Different Way to destruct the DAICO


// Casting a Vote for Voting(True for agree and False for Disagree)
function _SetRaiseProposal(uint256 _tap) public {
    _setRaiseProposal();
    tempTap = _tap;
}
function _SetDestructProposal() public {
    _setDestructProposal();
}

function _ProposalVote(bool _vote) public currentProposal isValidTokenHolder {

    _Vote(_vote);

}
// Tallying all the votes to take a decision

function _tallyingVotes() public {
    require(now > registry[proposalNumber].votingEnd);
    bool result = _tallyVotes();
    _afterVoteAction(result);

}

function _afterVoteAction(bool result ) internal {
    if(result && proposal == "Raise") {
          _raiseTap(tempTap);
          ongoingProposal == false;

    } else if (result && proposal == "Destruct") {
        investorWithdraw = true;
        ongoingProposal == false;

    } else {
        ongoingProposal == false;
    }
} 




  function _returnFunds() public contractIsinactive {
      require(!withdrawn[msg.sender]);
      withdrawn[msg.sender] = true;
      uint256 amount = (this.balance.mul(token.balanceOf(msg.sender))).div(token.totalSupply());
      msg.sender.transfer(amount);
      
     
  }



  function _raiseTap(uint256 _tap) internal {
      tap = _tap;
      ongoingProposal = false; 

  }
  

  



}

