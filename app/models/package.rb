class Package < ApplicationRecord
  belongs_to :product
  belongs_to :user
  validates :quantity, presence: true

  before_create :increase_product_amount
  before_update :update_product_amount
  before_destroy :decrease_product_amount

  private

  def increase_product_amount
    product.update(amount_left: product.amount_left + quantity)
    weight_one = Product.find_by(weight: 1)
    weight_two = Product.find_by(weight: 2)
    weight_one.update(amount_left: weight_one.amount_left - quantity)
    weight_two.update(amount_left: weight_two.amount_left - (quantity * 6))
  end

  def update_product_amount
    difference = quantity - quantity_was
    product.update(amount_left: product.amount_left + difference)
    weight_one = Product.find_by(weight: 1)
    weight_two = Product.find_by(weight: 2)
    weight_one.update(amount_left: weight_one.amount_left - difference)
    weight_two.update(amount_left: weight_two.amount_left - (difference * 6))
  end

  def decrease_product_amount
    product.update(amount_left: product.amount_left - quantity)
    weight_one = Product.find_by(weight: 1)
    weight_two = Product.find_by(weight: 2)
    weight_one.update(amount_left: weight_one.amount_left + quantity)
    weight_two.update(amount_left: weight_two.amount_left + (quantity * 6))
  end
end
