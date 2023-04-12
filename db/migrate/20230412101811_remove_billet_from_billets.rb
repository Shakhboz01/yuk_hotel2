class RemoveBilletFromBillets < ActiveRecord::Migration[7.0]
  def change
    remove_column :billets, :billet, :string
  end
end
