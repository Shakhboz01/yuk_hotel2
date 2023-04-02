# app/controllers/outcomers_controller.rb

class OutcomersController < ApplicationController
  include Pundit

  before_action :set_role
  before_action :set_outcomer, only: [:show, :edit, :update, :destroy]

  def show
    authorize Outcomer, :manage?
  end

  def edit
    authorize Outcomer, :manage?
  end

  def update
    authorize Outcomer, :manage?

    if @outcomer.update(outcomer_params)
      redirect_to @outcomer, notice: 'Outcomer was successfully updated.'
    else
      render :edit
    end
  end

  def show_buyer
    @outcomer = Outcomer.find_by(role: :покупатель)
  end

  def show_supplier
    @outcomer = Outcomer.find_by(role: :поставщик)
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
