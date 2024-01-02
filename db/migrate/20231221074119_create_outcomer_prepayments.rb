class CreateOutcomerPrepayments < ActiveRecord::Migration[7.0]
  def change
    create_table :outcomer_prepayments do |t|
      t.references :user, null: false, foreign_key: true
      t.references :outcomer, null: false, foreign_key: true
      t.integer :price

      t.timestamps
    end
  end
end
