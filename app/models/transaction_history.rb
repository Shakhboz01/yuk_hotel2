class TransactionHistory < ApplicationRecord
  belongs_to :income, optional: true
  belongs_to :expenditure, optional: true
  belongs_to :user
  validates :amount, presence: true
  validate :validate_expenditure_type_if_present

  after_create :increase_total_paid

  private

  def validate_expenditure_type_if_present
    if expenditure.present? && expenditure.expenditure_type != "на_товар"
      errors.add(:expenditure, "must have expenditure_type set to 'на_товар'")
    end
  end

  def increase_total_paid
    if expenditure_id.nil?
      income.increment!(:total_paid, amount)
    else
      expenditure.increment!(:total_paid, amount)
    end
  end
end
