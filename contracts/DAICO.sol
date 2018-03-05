pragma solidity ^0.4.18;

import "./Crowdsale/TimedCrowdsale.sol";
import "./Math/SafeMath.sol";

contract DAICO is TimedCrowdsale {


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
  uint256 public TotalYesVotes;
  uint256 public TotalNoVotes;
  uint256 public startVoting;
  uint256 public endVoting;
  uint256 public proposalNumber;

  bytes32 public proposal;
  bool public ongoingProposal;
  bool public investorWithdraw;
  mapping (address => bool) withdrawn;
  mapping (uint256 => mapping(address => bool)) VoteCast;

  event TapRaise(address,uint256,uint256,string);
  event Destruct();



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
  modifier noCurrentProposal {
      require(!ongoingProposal);
      require(token.balanceOf(msg.sender) > 0);
      _;
  }
  modifier currentProposal {
      require(ongoingProposal);
      require(endVoting > block.timestamp);
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

//TODO: Add relevant asserts for diff proposals

//TODO: Shift Voting Proposals to different Contract to make this contract cleaner 

//TODO: Find a Different Way to destruct the DAICO

// Proposal to raise Tap 
  function _setRaiseProposal(uint256 _tap) public noCurrentProposal {

      _startProposal("Raise");
      tempTap = _tap;
      TapRaise(msg.sender,startVoting,endVoting,"Vote To Raise Tap");   

  }

// Proposal to destroy the DAICO
  function _setDestructProposal() public noCurrentProposal {
      
      _startProposal("Destruct");
      TapRaise(msg.sender,startVoting,endVoting,"Vote To destruct DAICO and return funds");  

  }

// Casting a Yes Vote for Voting
  function _castYesVote() public currentProposal isValidTokenHolder {
 
      VoteCast[proposalNumber][msg.sender] == true;
      TotalYesVotes.add(1);

  }

// Casting a No Vote  
  function _castNoVote() public currentProposal isValidTokenHolder {

      VoteCast[proposalNumber][msg.sender] == true;
      TotalNoVotes.add(1);

  }

// Tallying all the votes to take a decision
  function _voteTallying() public {
      
      require(ongoingProposal);
      require(endVoting < block.timestamp);
      if (proposal == "Raise") {
          if (TotalYesVotes > TotalNoVotes) {
             _raiseTap(tempTap);

          } else {
              tempTap = 0;
              ongoingProposal = false;
          }

      } else {
         if (TotalYesVotes > TotalNoVotes) {
             tap = 0;
             investorWithdraw = true;

          } else {
             ongoingProposal = false; 
          } 

      }
  }
  function _returnFunds() public contractIsinactive {
      require(!withdrawn[msg.sender]);
      withdrawn[msg.sender] = true;
      uint256 amount = (this.balance.mul(token.balanceOf(msg.sender))).div(token.totalSupply());
      msg.sender.transfer(amount);
      
     
  }

  function _startProposal(bytes32 _proposal) internal {
      ongoingProposal = true;
      startVoting = block.timestamp;
      endVoting = startVoting.add(1209600);
      proposalNumber.add(1);
      proposal = _proposal;

  }

  function _raiseTap(uint256 _tap) internal {
      tap = _tap;
      ongoingProposal = false; 

  }
  

  



}

