require "test_helper"

class TransactionsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = users(:one)
    @account = accounts(:one)
    sign_in_as(@user)
  end

  test "should create transaction and update balance" do
    initial_balance = @account.balance || 0
    assert_difference("Transaction.count") do
      post account_transactions_url(@account), params: {
        transaction: {
          amount: 50.0,
          category: "Food",
          transaction_date: Date.today,
          description: "Lunch"
        }
      }
    end

    @account.reload
    assert_equal initial_balance + 50.0, @account.balance
    assert_redirected_to account_url(@account)
    assert_equal "Transaction recorded.", flash[:notice]
  end

  test "should create transaction via turbo_stream" do
    assert_difference("Transaction.count") do
      post account_transactions_url(@account), params: {
        transaction: {
          amount: 50.0,
          category: "Food",
          transaction_date: Date.today,
          description: "Lunch"
        }
      }, as: :turbo_stream
    end

    assert_response :success
    assert_match /turbo-stream action="prepend" target="transactions"/, response.body
    assert_match /turbo-stream action="remove" target="no-transactions"/, response.body
    assert_match /turbo-stream action="replace" target="account_#{@account.id}_balance"/, response.body
  end

  test "should destroy transaction via turbo_stream" do
    transaction = @account.transactions.create!(amount: 100.0, transaction_date: Date.today)

    assert_difference("Transaction.count", -1) do
      delete account_transaction_url(@account, transaction), as: :turbo_stream
    end

    assert_response :success
    assert_match /turbo-stream action="remove" target="transaction_#{transaction.id}"/, response.body
    assert_match /turbo-stream action="replace" target="account_#{@account.id}_balance"/, response.body
  end
end
