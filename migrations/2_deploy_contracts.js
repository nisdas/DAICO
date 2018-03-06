var SafeMath = artifacts.require("SafeMath");
var DAICO = artifacts.require("DAICO");


module.exports = function(deployer) {
  deployer.deploy(SafeMath);
  deployer.link(SafeMath,DAICO);
  deployer.deploy(DAICO);

  
};
