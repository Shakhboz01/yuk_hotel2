class BilletCrudOperation < ActiveInteraction::Base
  integer :quantity
  object :waste_paper_proportion

  def execute
    waste_paper_proportion.proportion_details.each do |proportion_detail|
      proportion_percentage = proportion_detail.percentage
      proportion_detail.product.update(amount_left: proportion_detail.product.amount_left - (quantity * proportion_percentage))
    end
  end
end
