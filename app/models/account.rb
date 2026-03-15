class Account < ApplicationRecord
  belongs_to :user
  has_many :transactions, dependent: :destroy

  validates :name, presence: true

  def recalculate_balance!
    # Update balance based on transaction sum
    update!(balance: transactions.sum(:amount))
  end
end
