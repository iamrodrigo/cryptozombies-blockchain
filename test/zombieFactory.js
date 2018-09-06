var ZombieFactory = artifacts.require("./ZombieFactory.sol");

contract("ZombieFactory", function(accounts) {
    
    it("Creates a Zombie", function() {
        return ZombieFactory.deployed().then(function(instance) {
            instance.createRandomZombie("Rodrigo");
            return instance.zombies(0)
        }).then(function(zombie) {
            assert.equal(zombie[0], "Rodrigo", "Contains Rodrigo's name");
        });
    });

    it("Fails when it tries to create a second zombie", function() {
        return ZombieFactory.deployed().then(function(instance) {
            return instance.createRandomZombie("Fail");
        }).then(assert.fail)
        .catch(function(error) {
            assert(error.message.indexOf('revert') >= 0, "Error message contains the word revert");
        });
    });
});