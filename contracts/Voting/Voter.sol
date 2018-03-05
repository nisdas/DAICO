pragma solidity ^0.4.18;

import "./VoterInterface.sol";
import "../Proposal/proposal.sol";

contract Voter is VoterInterface , proposal {


    modifier alreadyVoted {
        require(!VoteCast[proposalNumber][msg.sender]);
        _;
    }

    function _Vote(bool _vote) internal alreadyVoted {

        VoteCast[proposalNumber][msg.sender] = true;

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