class TransactionHistory < ApplicationRecord
  belongs_to :income, optional: true
  belongs_to :expenditure, optional: true

  validate :validate_expenditure_type_if_present

  private

  def validate_expenditure_type_if_present
    if expenditure.present? && expenditure.expenditure_type != "на_товар"
      errors.add(:expenditure, "must have expenditure_type set to 'на_товар'")
    end
  end
end
