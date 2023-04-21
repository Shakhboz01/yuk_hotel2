class Income < ApplicationRecord
  attr_accessor :product_price

  belongs_to :product, optional: true
  belongs_to :outcomer, optional: true
  belongs_to :user

  enum income_type: %i[на_товар трансакция]

  validates :price, presence: true, unless: -> { на_товар? }
  before_create :increase_product_amount
  before_create :set_total_paid
  before_update :update_product_amount
  before_destroy :decrease_product_amount

  private

  def set_total_paid
    self.total_paid = price unless income_type == 'на_товар'
  end

  def increase_product_amount
    if на_товар?
      self.price = quantity * product_price.to_i
      product.increment!(:amount_left, quantity)
    else
      self.total_paid = price
    end

  end

  def update_product_amount
    return if трансакция?

    difference = quantity - quantity_was
    product.increment(:amount_left, difference)
  end

  def decrease_product_amount
    return if трансакция?

    product.decrement!(amount_left: product.amount_left - quantity)
  end
end
