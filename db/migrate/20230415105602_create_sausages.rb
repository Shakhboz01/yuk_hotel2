class CreateSausages < ActiveRecord::Migration[7.0]
  def change
    create_table :sausages do |t|
      t.references :user, null: false, foreign_key: true
      t.integer :quantity

      t.timestamps
    end
  end
end
