var ZombieFactory = artifacts.require("./ZombieFactory.sol");
var ZombieFeeding = artifacts.require("./ZombieFeeding.sol");

module.exports = function(deployer) {
  deployer.deploy(ZombieFactory);
  deployer.deploy(ZombieFeeding);
};
