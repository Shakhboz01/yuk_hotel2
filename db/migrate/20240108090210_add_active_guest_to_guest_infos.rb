class AddActiveGuestToGuestInfos < ActiveRecord::Migration[7.0]
  def change
    add_column :guest_infos, :avtive_guest, :boolean, default: true
  end
end
