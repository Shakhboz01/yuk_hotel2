class PackageCrudOperation < ActiveInteraction::Base
  array :data
  integer :user_id
  boolean :income_operation, default: false

  def execute
    if income_operation
      outcomer_id = data[0][1]
      hash = data.slice(1, data.length).to_h
    else
      hash = data.to_h
    end

    new_hash = {}

    hash.each do |key, value|
      if key.start_with?('quantity_')
        next if value.to_i.zero?

        new_hash[key.split('_')[1].to_i] = value
      end
    end

    new_hash.to_h.each do |product_id, quantity|
      if income_operation
        Income.create(
          user_id: user_id,
          product_id: product_id,
          outcomer_id: outcomer_id,
          quantity: quantity
        )
      else
        Package.create(
          product_id: product_id,
          user_id: user_id,
          quantity: quantity
        )
      end
    end
  end
end