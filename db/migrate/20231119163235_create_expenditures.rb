class CreateExpenditures < ActiveRecord::Migration[7.0]
  def change
    create_table :expenditures do |t|
      t.string :comment
      t.references :user, null: false, foreign_key: true
      t.integer :price
      t.integer :expenditure_type, default: 0

      t.timestamps
    end
  end
end
