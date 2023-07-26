class CreateTransactionHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :transaction_histories do |t|
      t.references :income, null: true, foreign_key: true
      t.references :user, null: false, foreign_key: true
      t.references :expenditure, null: true, foreign_key: true
      t.integer :amount

      t.timestamps
    end
  end
end
