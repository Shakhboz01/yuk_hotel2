class Outcomer < ApplicationRecord
  validates :name, uniqueness: true
  enum role: %i[покупатель поставщик]
end
