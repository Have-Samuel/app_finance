require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should have many accounts" do
    user = users(:one)
    assert_respond_to user, :accounts
  end

  test "should destroy accounts when user is destroyed" do
    user = users(:one)
    user.accounts.create!(name: "Test Account")
    assert_difference "Account.count", -1 do
      user.destroy
    end
  end
end
