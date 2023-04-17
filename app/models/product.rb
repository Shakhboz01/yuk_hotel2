class Product < ApplicationRecord
  has_many :product_prices
  has_many :expenditures
  validates :name, uniqueness: true
  validates :amount_left, presence: true

  def self.ransackable_associations(auth_object = nil)
    ["expenditures", "product_prices"]
  end
end
