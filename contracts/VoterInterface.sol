pragma solidity ^0.4.18;


contract VoterInterface {

  
  uint256 public TotalAgreeVotes;
  uint256 public TotalDisagreeVotes;
  mapping (uint256 => mapping(address => bool)) VoteCast;

  function _Vote(bool _vote) internal;
  function _tallyVotes() internal;



}