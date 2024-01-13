class RemoveCountryFromBookings < ActiveRecord::Migration[7.0]
  def change
    remove_column :bookings, :country
    add_column :guest_infos, :country, :string, default: ''
  end
end
