require "test_helper"

class TransactionTest < ActiveSupport::TestCase
  setup do
    @user = users(:one)
    @account = accounts(:one)
  end

  test "should update account balance on create" do
    initial_balance = @account.balance || 0
    amount = 50.0

    @account.transactions.create!(amount: amount, transaction_date: Time.current)
    @account.reload

    assert_equal initial_balance + amount, @account.balance
  end

  test "should update account balance on update" do
    transaction = @account.transactions.create!(amount: 100.0, transaction_date: Time.current)
    @account.reload
    assert_equal 100.0, @account.balance

    transaction.update!(amount: 50.0)
    @account.reload
    assert_equal 50.0, @account.balance
  end

  test "should update account balance on destroy" do
    transaction = @account.transactions.create!(amount: 100.0, transaction_date: Time.current)
    @account.reload
    assert_equal 100.0, @account.balance

    transaction.destroy
    @account.reload
    assert_equal 0.0, @account.balance
  end

  test "should be invalid without amount" do
    transaction = Transaction.new(account: @account, transaction_date: Time.current)
    assert_not transaction.valid?
    assert_includes transaction.errors[:amount], "can't be blank"
  end

  test "should be invalid without transaction_date" do
    transaction = Transaction.new(account: @account, amount: 100.0)
    assert_not transaction.valid?
    assert_includes transaction.errors[:transaction_date], "can't be blank"
  end
end
