class CreateBillets < ActiveRecord::Migration[7.0]
  def change
    create_table :billets do |t|
      t.references :user, null: false, foreign_key: true
      t.string :billet
      t.integer :quantity
      t.references :waste_paper_proportion, null: false, foreign_key: true

      t.timestamps
    end
  end
end
