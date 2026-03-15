class Transaction < ApplicationRecord
  belongs_to :account

  validates :amount, presence: true, numericality: true
  validates :transaction_date, presence: true
  # Automatically update account balance after changes
  after_save :update_account_balance
  after_destroy :update_account_balance

  private

  def update_account_balance
    account.recalculate_balance!
  end
end
