class CreateTransactionHistories < ActiveRecord::Migration[7.0]
  def change
    create_table :transaction_histories do |t|
      t.references :income, null: false, foreign_key: true
      t.references :expenditure, null: false, foreign_key: true
      t.string :amount

      t.timestamps
    end
  end
end
