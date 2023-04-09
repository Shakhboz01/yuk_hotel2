# weight # 0 for makalature # 1 for salafan # 2 for etiketka
class Product < ApplicationRecord
  has_many :product_prices
  has_many :expenditures
  validates :name, uniqueness: true

  def self.ransackable_associations(auth_object = nil)
    ["expenditures", "product_prices"]
  end
end
