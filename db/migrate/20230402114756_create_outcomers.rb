class CreateOutcomers < ActiveRecord::Migration[7.0]
  def change
    create_table :outcomers do |t|
      t.integer :role
      t.string :name
      t.boolean :active_outcomer, default: true

      t.timestamps
    end
  end
end
