class AddAllowedToUseToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :allowed_to_use, :boolean, default: true
  end
end
