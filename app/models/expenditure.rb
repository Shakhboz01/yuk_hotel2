class Expenditure < ApplicationRecord
  attr_accessor :product_price
  belongs_to :user, optional: true
  belongs_to :outcomer, optional: true
  belongs_to :product, optional: true
  belongs_to :executor, class_name: 'User',
                        foreign_key: 'executor_id', optional: true

  # don't change this enum
  enum expenditure_type: %i[на_товар трансакция аванс зарплата еда грузовик запчасть газ налог свет прочие]
  validates :price, presence: true, unless: -> { на_товар? }
  validate :if_worfer_payment_expenditure
  validate :if_product_expenditure

  scope :from_index_3, -> { where("expenditure_type >= ?", Expenditure.expenditure_types[:еда]) }
  scope :from_enum_to_enum, -> (x, y) { where(expenditure_type: x..y) }

  private

  def if_worfer_payment_expenditure
    if ['аванс', 'зарплата'].include?(expenditure_type) && user.nil?
      errors.add(:user, "error, please fill forms")
    end
  end

  def if_product_expenditure
    if expenditure_type == 'на_товар' && (outcomer.nil? || quantity.nil? || product.nil?)
      errors.add(:base, "error, please fill forms")
    elsif expenditure_type == 'на_товар' && !quantity.nil?
      if new_record?
        product.increment!(:amount_left, quantity)
      else
        old_record = Expenditure.find(id)
        old_record.product.update(amount_left: old_record.product.amount_left - old_record.quantity)
        product.update(amount_left: product.amount_left + quantity)
      end
      self.price = (product_price.to_i * quantity)
      self.total_paid = 0 if total_paid.nil?
    end
  end
end
