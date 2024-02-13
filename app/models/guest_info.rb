class GuestInfo < ApplicationRecord
  include ShiftIsPresent
  belongs_to :booking
  validates_presence_of :name
end
