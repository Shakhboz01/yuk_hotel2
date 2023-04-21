class IncomesController < ApplicationController
  include Pundit
  before_action :set_income, only: %i[ show edit update destroy ]

  def index
    authorize Income, :access?

    @q = Income.ransack(params[:q])
    @incomes = @q.result.order(id: :desc)
    @total_paid = @incomes.sum(:total_paid)
    @total_price = @incomes.sum(:price)
    @incomes = @incomes.page(params[:page]).per(40)

  end

  def show; end

  # GET /incomes/new
  def new
    authorize Income, :special_access?

    @for_transaction = params[:for_transaction]
    @product = Product.find(params[:product_id]) unless @for_transaction
    @income = Income.new

    if @for_transaction
      @income.income_type = 'трансакция'
    else
      @income.income_type = 'на_товар'
    end
  end

  # GET /incomes/1/edit
  def edit
    authorize Income, :access?

    @product = @income.product
    @for_transaction = @income.income_type == 'трансакция'
  end

  def create
    authorize Income, :special_access?

    @income = Income.new(income_params)
    @income.user_id = current_user.id

    respond_to do |format|
      if @income.save
        format.html { redirect_to main_page_path, notice: "Успешно создано." }
        format.json { render :show, status: :created, location: @income }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @income.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /incomes/1 or /incomes/1.json
  def update
    authorize Income, :access?

    respond_to do |format|
      if @income.update(income_params)
        format.html { redirect_to main_page_path, notice: "Успешно обновлено." }
        format.json { render :show, status: :ok, location: @income }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @income.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize Income, :manage?

    @income.destroy

    respond_to do |format|
      format.html { redirect_to incomes_url, notice: "успешно удален." }
      format.json { head :no_content }
    end
  end

  def define_outcomer
    @outcomers = Outcomer.where(active_outcomer: true).where(role: :покупатель)
  end

  def new_income
    PackageCrudOperation.run(
      data: params[:new_income].permit!.to_h.to_a,
      user_id: current_user.id,
      income_operation: true
    )

    if current_user.упаковщик?
      redirect_to roles_path
      sign_out current_user
    else
      redirect_to incomes_path, notice: 'успешно создано'
    end
  end

  private

  def set_income
    @income = Income.find(params[:id])
  end

  def income_params
    params.require(:income).permit(:income_type, :product_price, :product_id, :quantity, :outcomer_id, :price, :total_paid, :user_id)
  end
end
