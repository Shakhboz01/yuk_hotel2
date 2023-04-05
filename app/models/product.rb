class Product < ApplicationRecord
  has_many :product_prices
  validates :name, uniqueness: true
end
