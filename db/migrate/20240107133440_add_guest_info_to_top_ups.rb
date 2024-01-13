class AddGuestInfoToTopUps < ActiveRecord::Migration[7.0]
  def change
    add_reference :top_ups, :guest_info, null: false, foreign_key: true
  end
end
