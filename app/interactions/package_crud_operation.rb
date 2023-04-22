class PackageCrudOperation < ActiveInteraction::Base
  array :data
  integer :user_id
  boolean :income_operation, default: false

  def execute
    if income_operation
      outcomer_id = data[data.length - 3][1]
      price = data[data.length - 2][1].to_i
      total_paid = data[data.length - 1][1].to_i
      hash = data.slice(0, data.length - 3)
    else
      hash = data.to_h
    end

    new_hash = {}

    hash.each do |key, value|
      if key.start_with?('quantity_')
        next if value.to_i.zero?

        new_hash[key.split('_')[1].to_i] = value.to_i
      end
    end

    new_hash.to_h.each_with_index do |(product_id, quantity), index|
      if income_operation
        product_price = quantity * price
        total_current_paid =
          if index == (new_hash.to_h.length - 1)
            total_paid
          elsif total_paid >= product_price
            current_paid = product_price
            total_paid -= current_paid
            current_paid
          else
            total_paid
          end

        Income.create(
          user_id: user_id,
          product_id: product_id,
          outcomer_id: outcomer_id,
          quantity: quantity,
          price: product_price,
          total_paid: total_current_paid
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