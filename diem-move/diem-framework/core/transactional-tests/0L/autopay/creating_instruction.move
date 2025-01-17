//# init --parent-vasps Carol Alice Jim Bob
// Carol, Jim:     validators with 10M GAS
// Alice, Bob: non-validators with  1M GAS

// We test creation of autopay, retrieving it using same and different accounts
// Finally, we also test deleting of autopay

// Test to create instruction and retrieve it
//# run --admin-script --signers DiemRoot Alice
script {
  use DiemFramework::AutoPay;
  use Std::Signer;

  fun main(_dr: signer, sender: signer) {
    let sender = &sender;
    AutoPay::enable_autopay(sender);
    assert!(AutoPay::is_enabled(Signer::address_of(sender)), 73570001);
    AutoPay::create_instruction(sender, 1, 0, @Bob, 2, 5);
    let (type, payee, end_epoch, percentage) = AutoPay::query_instruction(
      Signer::address_of(sender), 1
    );
    assert!(type == 0, 7357005);
    assert!(payee == @Bob, 73570002);
    assert!(end_epoch == 2, 73570003);
    assert!(percentage == 5, 73570004);
  }
}
// check: EXECUTED

// Test to create another instruction also by alice.
// The account already has autopay enabled.
//# run --admin-script --signers DiemRoot Alice
script {
  use DiemFramework::AutoPay;
  use Std::Signer;

  fun main(_dr: signer, sender: signer) {
    let sender = &sender;
    assert!(AutoPay::is_enabled(Signer::address_of(sender)), 73570005);    
    AutoPay::create_instruction(sender, 2, 0, @Alice, 4, 5);
  }
}
// check: EXECUTED