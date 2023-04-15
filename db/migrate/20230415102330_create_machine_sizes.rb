class CreateMachineSizes < ActiveRecord::Migration[7.0]
  def change
    create_table :machine_sizes do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :devision

      t.timestamps
    end
  end
end
