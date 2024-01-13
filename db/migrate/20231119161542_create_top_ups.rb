class CreateTopUps < ActiveRecord::Migration[7.0]
  def change
    create_table :top_ups do |t|
      t.references :booking, null: false, foreign_key: true
      t.decimal :price
      t.string :comment

      t.timestamps
    end
  end
end
