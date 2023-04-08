class PagesController < ApplicationController
  def main_page
    @expenditures = Expenditure.all.order(id: :desc)
  end
end