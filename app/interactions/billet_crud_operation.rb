class BilletCrudOperation < ActiveInteraction::Base
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

    new_hash.to_h.each do |proportion_id, quantity|
      waste_paper_proportion = WastePaperProportion.find(proportion_id)
      Billet.create(
        waste_paper_proportion_id: proportion_id,
        user_id: user_id,
        quantity: quantity
      )
      waste_paper_proportion.proportion_details.each do |proportion_detail|
        proportion_percentage = proportion_detail.percentage
        proportion_detail.product.update(amount_left: proportion_detail.product.amount_left - (quantity.to_i * proportion_percentage))
      end
    end
  end
end
