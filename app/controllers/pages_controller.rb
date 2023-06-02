class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[roles]

  def main_page
    is_allowed = %w[админ менеджер].include?(current_user.role)

    return redirect_to request.referrer unless is_allowed

    @incomes =
      Income.order(id: :desc)
    @expenditures =
      Expenditure.includes(:outcomer, :product).order(id: :desc)

    @outcomers = Outcomer.where(active_outcomer: true).order(role: :desc)
    @overall_income = Income.sum(:price)
    @today_overall_income = Income.where('created_at > ?', DateTime.now.beginning_of_day)
    @today_real_income = @today_overall_income.sum(:total_paid)
    @today_overall_income = @today_overall_income.sum(:price)
    @real_income = Income.sum(:total_paid)

    @overall_expenditure = Expenditure.sum(:price)
    @today_overall_expenditure = Expenditure.where('created_at > ?', DateTime.now.beginning_of_day)
    @today_real_expenditure = @today_overall_expenditure.sum(:total_paid)
    @today_overall_expenditure = @today_overall_expenditure.sum(:price)
    @real_expenditure = Expenditure.sum(:total_paid)

    total_expenditure_with_prev_data =
      Expenditure.where('created_at < ?', DateTime.now.beginning_of_day)
                 .where('total_paid < price').sum(:price)
    @total_expenditure_with_todays_and_prev_data = @today_overall_expenditure + total_expenditure_with_prev_data

    total_income_with_prev_data =
      Income.where('total_paid < price')
            .where('created_at < ?', DateTime.now.beginning_of_day).sum(:price)
    @total_income_with_todays_and_prev_data = total_income_with_prev_data + @today_overall_income
  end

  def welcoming_page
    @role = current_user.role
  end

  def dashboard
    is_allowed = current_user.role == 'админ'

    return redirect_to request.referrer unless is_allowed

    trans_action = Expenditure.all
    income = Income.all

    if params[:filter].present?
      from = "#{params[:filter]['from(1i)']}-#{params[:filter]['from(2i)']}-#{params[:filter]['from(3i)']}".to_date.beginning_of_day
      till = "#{params[:filter]['till(1i)']}-#{params[:filter]['till(2i)']}-#{params[:filter]['till(3i)']}".to_date.beginning_of_day

      trans_action = trans_action.where(created_at: from..till)
      income = income.where(created_at: from..till)
    end
    # income
    @total_income_with_debt = income.sum(:price)
    @total_income_without_debt = @total_income_with_debt - income.sum(:total_paid)

    # outcome
    @total_outcome_with_debt = trans_action.sum(:price)
    @total_debt = trans_action.sum(:price) - trans_action.sum(:total_paid)
    @total_outcome_without_debt = @total_outcome_with_debt - @total_debt

    @daily_outcome = trans_action.totals_by_time_duration
    @daily_income = income.totals_by_time_duration
    customers = trans_action.joins(:outcomer).group('expenditures.outcomer_id').count.sort_by(&:last)
    @total_depters = trans_action.where('price > total_paid').pluck(:outcomer_id).uniq.count

    unless customers.empty?
      @most_active_customer = Outcomer.find(customers.last[0]).name
      @most_inactive_customer = Outcomer.find(customers.first[0]).name
    end
  end

  def roles
     @roles = [:приёмщик, :заготовщик, :оператор, :упаковщик, :другой, :админ, :менеджер]
  end
end