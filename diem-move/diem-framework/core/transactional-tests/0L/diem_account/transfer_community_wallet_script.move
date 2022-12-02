//# init --parent-vasps Alice Bob Jim Carol
// Alice, Jim:     validators with 10M GAS
// Bob, Carol: non-validators with  1M GAS

// Bob, the recipient wallet
// Carol, the community wallet


//# run --admin-script --signers DiemRoot Bob
script {
  use DiemFramework::DiemAccount;
  use Std::Vector;

  fun main(_dr: signer, _bob: signer) {
    // Genesis creates 6 validators by default which are already slow wallets,
    let list = DiemAccount::get_slow_list();
    //verify bob is not in the slow list
    assert!(Vector::length<address>(&list) == 6, 735701);
  }
}

//# run --admin-script --signers DiemRoot Carol
script {
  use DiemFramework::Wallet;
  use Std::Vector;

  fun main(_dr: signer, carol: signer) {
    Wallet::set_comm(&carol);
    let list = Wallet::get_comm_list();
    assert!(Vector::length(&list) == 1, 7357001);
  }
}

//# run --signers Carol --args @Bob 1 b"thanks.for.your.service"
//#     -- 0x1::TransferScripts::community_transfer