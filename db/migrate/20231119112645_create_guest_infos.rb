class CreateGuestInfos < ActiveRecord::Migration[7.0]
  def change
    create_table :guest_infos do |t|
      t.references :booking, null: false, foreign_key: true
      t.string :name
      t.string :phone_number
      t.integer :age

      t.timestamps
    end
  end
end
