class Outcomer < ApplicationRecord
  validates :name, uniqueness: true
  has_many :expenditures
  enum role: %i[покупатель поставщик]
end
