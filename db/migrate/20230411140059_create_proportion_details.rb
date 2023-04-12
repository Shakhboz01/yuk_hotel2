class CreateProportionDetails < ActiveRecord::Migration[7.0]
  def change
    create_table :proportion_details do |t|
      t.references :product, null: false, foreign_key: true
      t.references :waste_paper_proportion, null: false, foreign_key: true
      t.integer :percentage

      t.timestamps
    end
  end
end
