class CreateBooks < ActiveRecord::Migration[7.0]
  def change
    create_table :books do |t|
      t.integer :sold
      t.string :name
      t.boolean :active

      t.timestamps
    end
  end
end
