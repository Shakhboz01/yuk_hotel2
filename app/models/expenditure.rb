class Expenditure < ApplicationRecord
  attr_accessor :product_price
  belongs_to :user, optional: true
  belongs_to :outcomer, optional: true
  belongs_to :product, optional: true
  belongs_to :executor, class_name: 'User',
                        foreign_key: 'executor_id', optional: true

  # don't change this enum
  enum expenditure_type: %i[на_товар аванс зарплата еда грузовик запчасть газ налог свет прочие]
  validates :price, presence: true, unless: -> { на_товар? }
  validate :if_worker_payment_expenditure
  validate :if_product_expenditure
  validate :set_total_paid

  scope :from_index_2, -> { where("expenditure_type >= ?", Expenditure.expenditure_types[:еда]) }
  scope :from_enum_to_enum, -> (x, y) { where(expenditure_type: x..y) }

  scope :totals_by_time_duration, lambda { |day = 'day'|
    select("date_trunc('#{day}', created_at) AS duration, sum(price) as amount")
      .group('duration')
      .order('duration, amount')
      .map do |row|
        [
          row['duration'].strftime(day == 'hour' ? '%d-%b|%R' : '%D'),
          row.amount.to_f
        ]
    end
  }
  def self.ransackable_associations(auth_object = nil)
    ["executor", "outcomer", "product", "user"]
  end

  private

  def if_worker_payment_expenditure
    if ['аванс', 'зарплата'].include?(expenditure_type) && user.nil?
      errors.add(:user, "error, please fill forms")
    end
  end

  def set_total_paid
    self.total_paid = price unless expenditure_type == 'на_товар'
  end

  def if_product_expenditure
    if expenditure_type == 'на_товар' &&
     [outcomer, quantity, product, product_price].any?(&:blank?)
      errors.add(:base, "ошибка, пожалуйста, заполните формы")
    elsif expenditure_type == 'на_товар' && !quantity.nil?
      self.quantity = quantity * 80 if product.weight == 1

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
