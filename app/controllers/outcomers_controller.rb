# app/controllers/outcomers_controller.rb

class OutcomersController < ApplicationController
  include Pundit

  before_action :set_role
  before_action :set_outcomer, only: [:show, :edit, :update, :destroy]

  def show
    authorize Outcomer, :manage?

    if @outcomer.role == 'поставщик'
      trans_action = @outcomer.expenditures

      if params[:filter].present?
        from = "#{params[:filter]['from(1i)']}-#{params[:filter]['from(2i)']}-#{params[:filter]['from(3i)']}".to_date.beginning_of_day
        till = "#{params[:filter]['till(1i)']}-#{params[:filter]['till(2i)']}-#{params[:filter]['till(3i)']}".to_date.beginning_of_day

        trans_action = trans_action.where(created_at: from..till)
      end
      # income
      @total_outcome_with_debt = trans_action.sum(:price)
      @total_debt = trans_action.sum(:price) - trans_action.sum(:total_paid)
      @total_outcome_without_debt = @total_outcome_with_debt - @total_debt

      @daily_outcome = trans_action.totals_by_time_duration
    end
  end

  def edit
    authorize Outcomer, :manage?
  end

  def update
    authorize Outcomer, :manage?

    if @outcomer.update(outcomer_params)
      redirect_to @outcomer, notice: 'Outcomer was Успешно обновлено.'
    else
      render :edit
    end
  end

  def show_buyer
    @outcomer = Outcomer.find_by(role: :покупатель).order(:active_outcomer)
  end

  def show_supplier
    @outcomer = Outcomer.find_by(role: :поставщик).order(:active_outcomer)
  end

  def index
    authorize Outcomer, :manage?

    @outcomers = Outcomer.where(role: @role)
  end

  def new
    @outcomer = Outcomer.new(role: params[:role])
  end

  def create
    authorize Outcomer, :manage?

    @outcomer = Outcomer.new(outcomer_params)

    if @outcomer.save
      redirect_to @outcomer
    else
      render :new
    end
  end

  def toggle_active_outcomer
    authorize Outcomer, :manage?

    @outcomer = Outcomer.find(params[:id])
    if @outcomer.update(active_outcomer: !@outcomer.active_outcomer)
      flash[:success] = 'Статус успешно обновлен'
    else
      flash[:error] = 'Не удалось обновить статус'
    end
    redirect_to outcomers_path
  end

  private

  def set_outcomer
    @outcomer = Outcomer.find(params[:id])
  end

  def set_role
    @role = params[:role] || 'покупатель'
    @role = 'покупатель' unless Outcomer.roles.key?(@role.to_sym)
  end

  def outcomer_params
    params.require(:outcomer).permit(:name, :role)
  end
end
