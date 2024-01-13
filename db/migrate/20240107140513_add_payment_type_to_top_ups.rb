class AddPaymentTypeToTopUps < ActiveRecord::Migration[7.0]
  def change
    add_column :top_ups, :payment_type, :integer, default: 0
  end
end
