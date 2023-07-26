class Income < ApplicationRecord
  attr_accessor :product_price
  belongs_to :product, optional: true
  belongs_to :outcomer, optional: true
  belongs_to :user
  has_many :transaction_histories
  validates :price, presence: true
  before_create :decrease_product_amount
  before_update :update_product_amount
  before_destroy :increase_product_amount

  scope :totals_by_time_duration, lambda { |day = 'day'|
    select("date_trunc('#{day}', created_at) AS duration, sum(price) as amount")
      .group('duration')
      .order('duration, amount')
      .map do |row|
        [
          row['duration'].strftime(day == 'hour' ? '%d-%b|%R' : '%D'),
          row.amount.to_f
        ]
    end
  }

  private

  def increase_product_amount
    product.increment!(:amount_left, quantity)
  end

  def update_product_amount
    difference = quantity - quantity_was
    product.decrement!(:amount_left, difference)
  end

  def decrease_product_amount
    product.decrement!(:amount_left, quantity)
  end
end
