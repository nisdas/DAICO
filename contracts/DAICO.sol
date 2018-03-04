pragma solidity ^0.4.18;

import "./crowdsale.sol";
import "./SafeMath.sol";

contract DAICO is Crowdsale {


  using SafeMath for uint256;

  uint256 public openingTime;
  uint256 public closingTime;


  modifier onlyWhileOpen {
    require(now >= openingTime && now <= closingTime);
    _;
  }


  function DAICO(uint256 _openingTime, uint256 _closingTime) public {
    require(_openingTime >= now);
    require(_closingTime >= _openingTime);

    openingTime = _openingTime;
    closingTime = _closingTime;
  }


  function hasClosed() public view returns (bool) {
    return now > closingTime;
  }

  function _preValidatePurchase(address _beneficiary, uint256 _weiAmount) internal onlyWhileOpen {
    super._preValidatePurchase(_beneficiary, _weiAmount);
    
  }

}

