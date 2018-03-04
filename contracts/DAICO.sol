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
  uint256 public TotalVotes;
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

  function _setTap() onlyOwner onlyWhileClosed setTap {
      tap = this.balance.div(tapPeriod);
  }

  function _withdraw() onlyOwner onlyWhileClosed {
      require(TapSet > 0);
      uint256 amount = tap.mul(block.timestamp.sub(lastWithdrawn));
      lastWithdrawn = block.timestamp;
      wallet.transfer(amount);

  }

  function _OwnerModifyTap(uint256 _tap) onlyOwner {
      require(TapSet > 0);
      require(tap > _tap);
      tap = _tap;
   
  }

  function _setRaiseProposal() {
      require(ongoingProposal == false);
      ongoingProposal = true;
      TapRaise(msg.sender,block.timestamp,block.timestamp.add(1209600),"Vote To Raise Tap");   

  }

  function _setDestructProposal() {
      require(ongoingProposal == false);
      ongoingProposal = true;
      TapRaise(msg.sender,block.timestamp,block.timestamp.add(1209600),"Vote To destruct DAICO and return funds");

  }

  function _CastVote() internal {
      require(ongoingProposal == true);
      require(token.balanceOf(msg.sender) > 0);
      require(VoteCast[msg.sender] == false);
      VoteCast[msg.sender] == true;
      TotalVotes += 1;


  }
  function _returnFunds() internal {
     
  }
  function _raiseTap() internal {

  }
  

  



}

