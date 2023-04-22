class Participation < ApplicationRecord
  belongs_to :user
  enum status: %i[пришёл не_пришёл выходной]

  scope :allowed, lambda {
    where('created_at > ?', Date.current.beginning_of_day)
  }
end
