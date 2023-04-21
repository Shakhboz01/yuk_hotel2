class PagesController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[roles]

  def main_page

    is_allowed = %w[админ менеджер].include?(current_user.role)

    return redirect_to request.referrer unless is_allowed

    @incomes =
      Income.includes(:outcomers, :products).where(created_at: DateTime.current.beginning_of_day..DateTime.current.end_of_day)
            .order(id: :desc)
    @expenditures =
      Expenditure.includes(:outcomers, :products).where(created_at: DateTime.current.beginning_of_day..DateTime.current.end_of_day)
                 .order(id: :desc)
    @outcomers = Outcomer.where(active_outcomer: true).order(role: :desc)

    if params.dig(:q, :date)
      @date = params.dig(:q, :date).to_date
      @expenditures =
        Expenditure.includes(:outcomers, :products).where(created_at: @date.beginning_of_day..@date.end_of_day)
                   .order(id: :desc)
      @incomes =
        Income.includes(:outcomers, :products).where(created_at: @date.beginning_of_day..@date.end_of_day)
              .order(id: :desc)
    end
  end

  def welcoming_page
    @role = current_user.role
  end

  def dashboard
    is_allowed = current_user.role == 'админ'

    return redirect_to request.referrer unless is_allowed

    trans_action = Expenditure.all

    if params[:filter].present?
      from = "#{params[:filter]['from(1i)']}-#{params[:filter]['from(2i)']}-#{params[:filter]['from(3i)']}".to_date.beginning_of_day
      till = "#{params[:filter]['till(1i)']}-#{params[:filter]['till(2i)']}-#{params[:filter]['till(3i)']}".to_date.beginning_of_day

      trans_action = trans_action.where(created_at: from..till)
    end
    # income

    # @total_income_with_debt = trans_action.sum(:price)
    # @total_income_without_debt = @total_income_with_debt - @total_debt

    # income
    @total_outcome_with_debt = trans_action.sum(:price)
    @total_debt = trans_action.sum(:price) - trans_action.sum(:total_paid)
    @total_outcome_without_debt = @total_outcome_with_debt - @total_debt

    @daily_outcome = trans_action.totals_by_time_duration
    customers = trans_action.joins(:outcomer).group('expenditures.outcomer_id').count.sort_by(&:last)
    @total_depters = trans_action.where('price > total_paid').pluck(:outcomer_id).uniq.count

    unless customers.empty?
      @most_active_customer = Outcomer.find(customers.last[0]).name
      @most_inactive_customer = Outcomer.find(customers.first[0]).name
    end
  end

  def roles
     @roles = [:приёмщик, :заготовщик, :оператор, :упаковщик, :продавец, :другой, :админ, :менеджер]
  end
end