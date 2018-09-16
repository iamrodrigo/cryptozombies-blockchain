pragma solidity ^0.4.24;

import "./ZombieFeeding.sol";

contract ZombieHelper is ZombieFeeding {

  uint levelUpFee = 0.001 ether;

  // onlyOwner and owner come from Ownable
  function withdraw() external onlyOwner {
    owner.transfer(this.balance);
  }

  // Modifier, it usually goes through a condition before running the function is calling it
  modifier aboveLevel(uint _level, uint _zombieId) {
    require(zombies[_zombieId].level >= _level);
   // This is required!!
    _;
  }

  // onlyOwner modifier
  function setLevelUpFee(uint _fee) external onlyOwner {
    levelUpFee = _fee;
  }

  // Payable: The function requires ether to run
  function levelUp(uint _zombieId) external payable {
   require(msg.value == levelUpFee);
   zombies[_zombieId].level = zombies[_zombieId].level.add(1);
 }

  // External: can only be called outside the contract
  function changeName(uint _zombieId, string _newName) external aboveLevel(2, _zombieId)  onlyOwnerOf(_zombieId) {
    zombies[_zombieId].name = _newName;
  }

  // External: can only be called outside the contract
  function changeDna(uint _zombieId, uint _newDna) external aboveLevel(20, _zombieId)  onlyOwnerOf(_zombieId) {
    zombies[_zombieId].dna = _newDna;
  }

  // https://cryptozombies.io/en/lesson/3/chapter/12
  function getZombiesByOwner(address _owner) external view returns(uint[]) {
    uint[] memory result = new uint[](ownerZombieCount[_owner]);
    uint counter = 0;
    for(uint i = 0;i < zombies.length; i++) {
      if (zombieToOwner[i] == _owner) {
        result[counter] = i;
        counter++;
      }
    }
    return result;
  }
}