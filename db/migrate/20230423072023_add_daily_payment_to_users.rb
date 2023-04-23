class AddDailyPaymentToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :daily_payment, :integer, default: 0
  end
end
