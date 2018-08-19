var ZombieFactory = artifacts.require("./ZombieFactory.sol");

contract("Election", function(accounts) {
    
    it("Creates a Zombie", function() {
        return ZombieFactory.deployed().then(function(instance) {
            instance.createRandomZombie("Rodrigo");
            return instance.zombies(0)
        }).then(function(zombie) {
            assert.equal(zombie[0], "Rodrigo", "Contains Rodrigo's name");
        });
    });
});