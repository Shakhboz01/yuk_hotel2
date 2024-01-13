class CreateShifts < ActiveRecord::Migration[7.0]
  def change
    create_table :shifts do |t|
      t.references :user, null: false, foreign_key: true
      t.datetime :closed_at, default: nil
      t.decimal :total_income
      t.decimal :total_expenditure

      t.timestamps
    end
  end
end
