class CreateHomes < ActiveRecord::Migration[7.0]
  def change
    create_table :homes do |t|
      t.integer :number
      t.string :comment
      t.integer :number_of_people
      t.integer :home_type
      t.integer :price

      t.timestamps
    end
  end
end
