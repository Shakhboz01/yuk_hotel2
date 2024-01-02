class OutcomerPrepayment < ApplicationRecord
  belongs_to :user
  belongs_to :outcomer
  validates_presence_of :price
end
