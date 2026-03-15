class CreateTransactions < ActiveRecord::Migration[8.1]
  def change
    create_table :transactions do |t|
      t.belongs_to :account, null: false, foreign_key: true
      t.decimal :amount, precision: 15, scale: 2
      t.string :description
      t.string :category
      t.datetime :transaction_date

      t.timestamps
    end
  end
end
