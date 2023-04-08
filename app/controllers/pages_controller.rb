class PagesController < ApplicationController
  def main_page
    is_allowed = %w[админ менеджер].include?(current_user.role)

    return redirect_to request.referrer unless is_allowed

    @expenditures = Expenditure.all.order(id: :desc)
  end

  def welcoming_page
  end
end