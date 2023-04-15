class CreateEndProducts < ActiveRecord::Migration[7.0]
  def change
    create_table :end_products do |t|
      t.integer :amount_left
      t.string :name

      t.timestamps
    end
  end
end
