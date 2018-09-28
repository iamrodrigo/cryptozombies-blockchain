pragma solidity ^0.4.24;

import "./Ownable.sol";
import "./SafeMath.sol";
import "./SafeMath32.sol";
import "./SafeMath16.sol";

contract ZombieFactory is Ownable {

    using SafeMath for uint256;
    using SafeMath32 for uint32;
    using SafeMath16 for uint16;

    event NewZombie(uint zombieId, string name, uint dna);

    uint dnaDigits = 16;
    uint dnaModulus = 10 ** dnaDigits;
    uint cooldownTime = 1 days;

    /**
    If you have multiple uints inside a struct, using a smaller-sized uint
    when possible will allow Solidity to pack these variables together to
    take up less storage. For example:
    */
    struct Zombie {
      string name;
      uint dna;
      uint32 level;
      uint32 readyTime;
      uint16 winCount;
      uint16 lossCount;
    }

    /**
    These variables (mapping and Zombie[] return a promise, 
    so to get the values of them we need to
    
    > instance.zombies(0).then(function(z){ a = z})
    > a[0]
     */

    Zombie[] public zombies;

    // id = 1 => address = 0x5a4b3f2cc2d3a4bc6dee3
    mapping (uint => address) public zombieToOwner;
    
    // address = 0x5a4b3f2cc2d3a4bc6dee3 => count = 3 Zombies
    mapping (address => uint) ownerZombieCount;

    /* internal: can only be called within the contract itself and any derived contracts (similar to protected in oop). */
    function _createZombie(string _name, uint _dna) internal {
        // push returns the length of zombies
        // Verify if returns 0 or 1
        uint id = zombies.push(Zombie(_name, _dna, 1, uint32(now + cooldownTime), 0, 0)) - 1;
        
        zombieToOwner[id] = msg.sender;
        ownerZombieCount[msg.sender] = ownerZombieCount[msg.sender].add(1);

        // Emit an event telling to the listeners that a new zombie was created
        emit NewZombie(id, _name, _dna);
    }

    /* view: that function will not modify state of contract, i.e. not modify variables, not emit events etc.*/
    /* The above function doesn't actually change state in Solidity — e.g. it doesn't change
    any values or write anything.
    So in this case we could declare it as a view function, meaning it's only viewing the data
     but not modifying it:.*/
    function _generateRandomDna(string _str) private view returns (uint) {
        // Always strings are handled with keccak256 (to compare or whatever you need)
        uint rand = uint(keccak256(_str));
        return rand % dnaModulus;
    }

    function createRandomZombie(string _name) public {
        // require is a validation. If the validation fails, the code doesnt continue
        require(ownerZombieCount[msg.sender] == 0);
        uint randDna = _generateRandomDna(_name);
        randDna = randDna - randDna % 100;
        _createZombie(_name, randDna);
    }
}
