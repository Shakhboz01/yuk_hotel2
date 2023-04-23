class Refund < ApplicationRecord
  belongs_to :product
  belongs_to :user
  validates :quantity, presence: true
  before_create :decrease_product_amount_left

  private

  def decrease_product_amount_left
    product.decrement!(:amount_left, quantity)
  end
end
