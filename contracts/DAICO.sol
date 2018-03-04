pragma solidity ^0.4.18;

import "./crowdsale.sol";
import "./SafeMath.sol";

contract DAICO is Crowdsale {


  using SafeMath for uint256;

  uint256 public openingTime;
  uint256 public closingTime;
  uint256 public TapSet;

  /* The length the funds are held in the contract till the full amount is 
     ditributed to the team(in seconds)
  */
  uint256 public tapPeriod;

  //Tap Rate at which developers can withdraw funds(wei/sec)
  uint256 public tap;


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


  function DAICO(uint256 _openingTime, uint256 _closingTime, uint256 _tapPeriod) public {
    require(_openingTime >= now);
    require(_closingTime >= _openingTime);
    require(_tapPeriod >= 2);

    tapPeriod = _tapPeriod * 365 * 24 * 60 * 60;
    openingTime = _openingTime;
    closingTime = _closingTime;

  }


  function _hasClosed() public view returns (bool) {
    return now > closingTime;
  }

  function _setTap() internal onlyWhileClosed {
      tap = this.balance / tapPeriod ;
  }

  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
    super._preValidatePurchase(_beneficiary, _weiAmount);
    
  }

}

