class AddWeightToProducts < ActiveRecord::Migration[7.0]
  def change
    add_column :products, :weight, :integer, default: 0
  end
end
