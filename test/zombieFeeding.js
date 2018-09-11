var ZombieFeeding = artifacts.require("./ZombieFeeding.sol");

contract("ZombieFeeding", function(accounts) {
    it("Feed a zombie", function() {
        return ZombieFeeding.deployed().then(function(instance) {
            instance.feedAndMultiply(0, 2, "dog");
            return instance.zombies(1);
        }).then(function(zombie) {
            assert.equal(zombie[0], "NoNsame", "Contains Rodrigo's name");
        });
    });
});    