  pragma solidity ^0.4.18;

  import "./Token/Token.sol";
  import "./InterfaceProposal.sol";

  contract proposal is InterfacePropsal {

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

  modifier noCurrentProposal {
      require(!ongoingProposal);
      require(token.balanceOf(msg.sender) > 0);
      _;
  }
  modifier currentProposal {
      require(ongoingProposal);
      require(registry[proposalNumber].votingEnd > block.timestamp);
      _;
  }
// Proposal to raise Tap 
  function _setRaiseProposal(uint256 _tap) public noCurrentProposal  {

      _startProposal("Raise");
      tempTap = _tap;
      TapRaise(msg.sender,startVoting,endVoting,"Vote To Raise Tap");   

  }

// Proposal to destroy the DAICO
  function _setDestructProposal() public noCurrentProposal  {

      _startProposal("Destruct");
      Destruct(msg.sender,startVoting,endVoting,"Vote To destruct DAICO and return funds");  

  }

   function _startProposal(bytes32 _proposal) internal {
      ongoingProposal = true;
      startVoting = block.timestamp;
      endVoting = startVoting.add(1209600);
      proposalNumber.add(1);
      proposal = _proposal;

  }

  }