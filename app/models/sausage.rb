class Sausage < ApplicationRecord
  belongs_to :user
  has_one :machine_size, through: :user
  validates :quantity, presence: true

  validate :user_has_machine_size

  scope :created_this_month, -> {
    where(created_at: Time.current.beginning_of_month..Time.current.end_of_month)
  }
  private

  def user_has_machine_size
    return errors.add(:base, 'Оператор должен иметь станок или вы не оператор') if user.machine_size.nil? || !user.оператор?
  end
end
