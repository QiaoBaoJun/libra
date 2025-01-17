//# init --validators Alice Bob Carol Dave Eve Frank

// Testing if validator set remains the same if the size of eligible 
// validators falls below 4

// ALICE is CASE 1
// BOB is CASE 2
// CAROL is CASE 2
// DAVE is CASE 2
// EVE is CASE 3
// FRANK is CASE 2

//# block --proposer Alice --time 1 --round 0

//! NewBlockEvent

//# run --admin-script --signers DiemRoot Alice
script {
    use DiemFramework::TowerState;

    fun main(_dr: signer, sender: signer) {
        // Miner is the only one that can update their mining stats. 
        // Hence this first transaction.

        TowerState::test_helper_mock_mining(&sender, 5);
        assert!(TowerState::test_helper_get_count(&sender) == 5, 7357008005001);
    }
}
//check: EXECUTED

//# run --admin-script --signers DiemRoot Eve
script {
    use DiemFramework::TowerState;

    fun main(_dr: signer, sender: signer) {
        // Miner is the only one that can update their mining stats. 
        // Hence this first transaction.

        TowerState::test_helper_mock_mining(&sender, 5);
        assert!(TowerState::test_helper_get_count(&sender) == 5, 7357008005002);
    }
}
//check: EXECUTED

//# run --admin-script --signers DiemRoot DiemRoot
script {
    use DiemFramework::Stats;
    use Std::Vector;
    use DiemFramework::DiemSystem;

    fun main(vm: signer, _: signer) {
        let voters = Vector::singleton<address>(@Alice);
        Vector::push_back<address>(&mut voters, @Bob);
        // Vector::push_back<address>(&mut voters, @Carol);
        // Vector::push_back<address>(&mut voters, @Dave);
        // Skip Eve.
        // Vector::push_back<address>(&mut voters, @Eve);
        // Vector::push_back<address>(&mut voters, @Frank);

        let i = 1;
        while (i < 15) {
            // Mock the validator doing work for 15 blocks, and stats being updated.
            Stats::process_set_votes(&vm, &voters);
            i = i + 1;
        };

        assert!(DiemSystem::validator_set_size() == 6, 7357008005003);
        assert!(DiemSystem::is_validator(@Alice) == true, 7357008005004);
    }
}
//check: EXECUTED

//////////////////////////////////////////////
///// Trigger reconfiguration at 61 seconds ////
//# block --proposer Alice --time 61000000 --round 15

///// TEST RECONFIGURATION IS HAPPENING ////
// check: NewEpochEvent
//////////////////////////////////////////////

//# run --admin-script --signers DiemRoot DiemRoot
script {
    use DiemFramework::DiemSystem;
    use DiemFramework::DiemConfig;

    fun main() {
        // We are in a new epoch.
        assert!(DiemConfig::get_current_epoch() == 2, 7357008005005);
        // Tests on initial size of validators
        assert!(DiemSystem::validator_set_size() == 6, 7357008005006);
    }
}
//check: EXECUTED