 pragma solidity ^0.4.18;

  import "./Token/Token.sol";

  contract InterfaceProposal {

  Token public token;    

  uint256 public proposalNumber;    
  bytes32 public proposal;
  bool public ongoingProposal;
  bool public investorWithdraw;
  mapping (uint256 => proposals) registry;

  event TapRaise(address,uint256,uint256,string);
  event Destruct(address,uint256,uint256,string);
  

  struct proposals {

   address proposalSetter;
   uint256 votingStart;
   uint256 votingEnd;
   bytes32 proposalType;

  }

// Proposal to raise Tap 
  function _setRaiseProposal() internal;

// Proposal to destroy the DAICO
  function _setDestructProposal() internal;

   function _startProposal(bytes32 _proposal) internal;

  }