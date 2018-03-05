pragma solidity ^0.4.18;

import "./VoterInterface.sol";
import "./proposal.sol";

contract Voter is VoterInterface {

    proposal public proposalInst;

    modifier alreadyVoted {
        require(!VoteCast[proposalInst.proposalNumber][msg.sender]);
        _;
    }

    function _Vote(bool _vote) internal alreadyVoted {

        VoteCast[proposalInst.proposalNumber][msg.sender] = true;

        if (_vote) {

        TotalAgreeVotes += 1;
       
       } else {

        TotalDisagreeVotes += 1;

       }
}
   function _tallyVotes() internal returns(bool) {

       if(TotalAgreeVotes > TotalDisagreeVotes ) {
           return true;
       } else {
           return false;
       }



   }

}