  pragma solidity ^0.4.18;

  import "./Token/Token.sol";
  import "./InterfaceProposal.sol";
  import "./Math/SafeMath.sol";

  contract proposal is InterfaceProposal {

  using SafeMath for uint256;

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
  function _setRaiseProposal(uint256 _tap) public noCurrentProposal {

      _startProposal("Raise");
      //tempTap = _tap;
      TapRaise(msg.sender, registry[proposalNumber].votingStart, registry[proposalNumber].votingEnd,"Vote To Raise Tap");   

  }

// Proposal to destroy the DAICO
  function _setDestructProposal() public noCurrentProposal {

      _startProposal("Destruct");
      Destruct(msg.sender, registry[proposalNumber].votingStart, registry[proposalNumber].votingEnd,"Vote To destruct DAICO and return funds");  

  }

   function _startProposal(bytes32 _proposal) internal {
      ongoingProposal = true;
      proposalNumber.add(1);
      registry[proposalNumber].votingStart = block.timestamp;
      registry[proposalNumber].votingEnd = block.timestamp.add(1209600);
      proposal = _proposal;

  }

  }