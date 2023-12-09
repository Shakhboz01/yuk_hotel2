class Outcomer < ApplicationRecord
  validates :name, uniqueness: true
  has_many :expenditures
  has_many :incomes
  enum role: %i[покупатель поставщик]

  scope :with_weight_and_role, ->(has_zero_weight = true) {
    if has_zero_weight
      includes(:expenditures).where(expenditures: { product_id: Product.where(weight: 0).pluck(:id) }, role: 1).or(where(expenditures: { id: nil }, role: 1)).distinct
    else
      includes(:expenditures).where(expenditures: { product_id: Product.where.not(weight: 0).pluck(:id) }, role: 1).or(where(expenditures: { id: nil }, role: 1)).distinct
    end
  }

  def self.debetors
    buyers = Outcomer.покупатель.includes(:incomes).select {|outcomer| outcomer.incomes.sum(:total_paid) < outcomer.incomes.sum(:price)}.count
    sellers = Outcomer.поставщик.includes(:expenditures).select {|outcomer| outcomer.expenditures.sum(:total_paid) > outcomer.expenditures.sum(:price)}.count
    buyers + sellers
  end

  def self.creditors(debt = false)
    buyers = Outcomer.покупатель.includes(:incomes).select {|outcomer| outcomer.incomes.sum(:total_paid) > outcomer.incomes.sum(:price)}
    sellers = Outcomer.поставщик.includes(:expenditures).select {|outcomer| outcomer.expenditures.sum(:total_paid) < outcomer.expenditures.sum(:price)}
    buyers.count + sellers.count
  end
end
