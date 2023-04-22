class RemoveIncomeTypeFromIncomes < ActiveRecord::Migration[7.0]
  def change
    remove_column :incomes, :income_type, :integer
  end
end
