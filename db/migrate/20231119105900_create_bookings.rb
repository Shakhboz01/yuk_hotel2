class CreateBookings < ActiveRecord::Migration[7.0]
  def change
    create_table :bookings do |t|
      t.integer :number_of_people
      t.datetime :finished_at, default: nil
      t.boolean :breakfast_included, default: true
      t.references :home, null: false, foreign_key: true
      t.string :country

      t.timestamps
    end
  end
end
