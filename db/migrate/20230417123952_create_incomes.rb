class CreateIncomes < ActiveRecord::Migration[7.0]
  def change
    create_table :incomes do |t|
      t.integer :income_type, default: 0
      t.references :product, foreign_key: true
      t.integer :quantity, default: 0
      t.references :outcomer, null: false, foreign_key: true
      t.integer :price, default: 0
      t.integer :total_paid, default: 0
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
