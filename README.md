# DAICO

### Implementation of DAICO 

More details regarding it can be found here : https://ethresear.ch/t/explanation-of-daicos/465

A basic implemenation that is based on the post by Vitalik, regarding Decentralized Autonomous Initial Coin Offerings

This implementation is built on top of the open zeppelin smart contract library. All the relevant code can be found in `./contracts/DAICO.sol` 

Included in implementation :

`uint256 public tap` , this refers to the amount in wei/sec that the development team is allowed to withdraw

`_setRaiseProposal()` , This allows any tokenholder to launch a proposal to raise the tap of the dev team

`_setDestructProposal()`, this allows any tokenholder to launch a proposal to shut down the DAICO and return the remaining funds to the tokenholders

Still a work in progress