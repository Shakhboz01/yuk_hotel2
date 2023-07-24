class ExpendituresController < ApplicationController
  before_action :set_expenditure, only: %i[ show edit update destroy ]

  include Pundit

  # GET /expenditures or /expenditures.json
  def index
    authorize Expenditure, :manage?

    @expenditure_types = Expenditure.expenditure_types.sort
    @q = Expenditure.from_index_2.ransack(params[:q])
    @expenditures = @q.result.order(id: :desc)
    @sum = @expenditures.sum(&:price)

    @expenditures = @expenditures.page(params[:page]).per(40)
  end


  def payment_expenditure
    @expenditure_types = [['зарплата', 3], ['аванс', 2]]
    @q = Expenditure.from_enum_to_enum(1, 2).ransack(params[:q])
    @payment_expenditures = @q.result.order(id: :desc)
    @sum = @payment_expenditures.sum(&:price)

    @payment_expenditures = @payment_expenditures.page(params[:page]).per(40)
  end

  def product_expenditure
    @q = Expenditure.на_товар.ransack(params[:q])

    @product_expenditures = @q.result.order(id: :desc)
    @sum = @product_expenditures.sum(&:price)
    @total_paid_sum = @product_expenditures.sum(&:total_paid)

    @product_expenditures = @product_expenditures.page(params[:page]).per(40)
  end

  # GET /expenditures/1 or /expenditures/1.json
  def show
  end

  # GET /expenditures/new
  def new
    # params: for_product: boolean, if false then it is for payment
    @action = 'other'

    @expenditure = Expenditure.new

    if params[:product_id].present?
      @product = Product.find(params[:product_id])
      @action = @action = 'for_product'

      # define weight to sort outcomers
      @outcomers = Outcomer.with_weight_and_role(@product.weight.zero?)

      return request.referrer unless @product
    end

    if params[:expenditure_type].present?
      @expenditure_type = params[:expenditure_type]
    end

    if defined?(@expenditure_type) && ['аванс', 'зарплата'].include?(@expenditure_type)
      @action = 'payment'
    end
  end

  # GET /expenditures/1/edit
  def edit
    authorize Expenditure, :manage?

    @action = 'other'

    unless @expenditure.product_id.nil?
      @product = @expenditure.product
      @action = @action = 'for_product'
      @outcomers = Outcomer.with_weight_and_role(@product.weight.zero?)

      return request.referrer unless @product
    end


    @expenditure_type = @expenditure.expenditure_type

    if ['аванс', 'зарплата'].include?(@expenditure_type)
      @action = 'payment'
    end
  end

  # POST /expenditures or /expenditures.json
  def create
    @expenditure = Expenditure.new(expenditure_params)
    @expenditure.executor_id = current_user.id
    if @expenditure.save
      unless ['админ', 'менеджер'].include?(current_user.role)
        redirect_to roles_path
        sign_out current_user
        return
      end

      respond_to do |format|
        format.html do
          redirect_to case @expenditure.expenditure_type
          when 'на_товар', 'трансакция'
            if current_user.role == 'приёмщик'
              products_path
            else
              product_expenditure_expenditures_path
            end
          when 'аванс', 'зарплата'
            payment_expenditure_expenditures_path
          else
            expenditures_path
          end, notice: "Расход успешно создан."
        end
        format.json { render :show, status: :created, location: @expenditure }
        format.js   # handle JS format
      end
    else
      respond_to do |format|
        format.html { redirect_to request.referrer, notice: @expenditure.errors.messages.values.join() }
        format.json { render json: @expenditure.errors, status: :unprocessable_entity }
        format.js   # handle JS format
      end
    end
  end

  # PATCH/PUT /expenditures/1 or /expenditures/1.json
  def update
    authorize Expenditure, :manage?

    respond_to do |format|
      if @expenditure.update(expenditure_params)
        format.html { redirect_to main_page_path, notice: "Расход успешно обновлен." }
        format.json { render :show, status: :ok, location: @expenditure }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @expenditure.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    authorize Expenditure, :admin?

    @expenditure.destroy

    respond_to do |format|
      format.html { redirect_to expenditures_url, notice: "Expenditure was успешно удален." }
      format.json { head :no_content }
    end
  end

  private
    def set_expenditure
      @expenditure = Expenditure.find(params[:id])
    end

    def expenditure_params
      params.require(:expenditure).permit(:executor_id, :comment, :outcomer_id, :quantity, :user_id, :product_id, :expenditure_type, :price, :product_price, :total_paid)
    end
end
