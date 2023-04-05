class CreateExpenditures < ActiveRecord::Migration[7.0]
  def change
    create_table :expenditures do |t|
      t.bigint :executor_id
      t.string :comment
      t.references :user, foreign_key: true
      t.references :product, foreign_key: true
      t.references :outcomer, foreign_key: true
      t.integer :expenditure_type
      t.integer :price
      t.integer :quantity
      t.integer :total_paid

      t.timestamps
    end
  end
end
