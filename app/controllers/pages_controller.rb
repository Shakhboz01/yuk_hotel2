class PagesController < ApplicationController
  def main_page
    is_allowed = %w[админ менеджер].include?(current_user.role)

    return redirect_to request.referrer unless is_allowed

    @expenditures = Expenditure.all.order(id: :desc)
    @outcomers = Outcomer.where(active_outcomer: true).order(role: :desc)

    if params.dig(:q, :date)
      @date = params.dig(:q, :date).to_date
      @expenditures =
        Expenditure.where(created_at: @date.beginning_of_day..@date.end_of_day)
                   .order(id: :desc)
    end
  end

  def welcoming_page
    @role = current_user.role
  end
end