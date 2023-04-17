class PackageCrudOperation < ActiveInteraction::Base
  array :data
  integer :user_id

  def execute
    hash = data.to_h
    new_hash = {}
    hash.each do |key, value|
      if key.start_with?('quantity_')
        next if value.to_i.zero?

        new_hash[key.split('_')[1].to_i] = value
      end
    end

    new_hash.to_h.each do |product_id, quantity|
      product = Product.find(product_id)
      Package.create(
        product_id: product_id,
        user_id: user_id,
        quantity: quantity
      )
    end
  end
end