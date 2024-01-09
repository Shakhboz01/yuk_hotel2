class TransactionHistoriesController < ApplicationController
  before_action :set_transaction_history, only: %i[ show edit update destroy ]

  # GET /transaction_histories or /transaction_histories.json
  def index
    if params[:expenditure_id]
      expenditures = Expenditure.find(params[:expenditure_id]).outcomer.expenditures.pluck(:id)
      @transaction_histories = TransactionHistory.where(expenditure_id: expenditures).order(id: :desc)

      @debetor = Expenditure.find(params[:expenditure_id]).outcomer.name
    elsif params[:income_id]
      incomes = Income.find(params[:income_id]).outcomer.incomes.pluck(:id)
      @transaction_histories = TransactionHistory.where(income_id: incomes).order(id: :desc)
      @debetor = Income.find(params[:income_id]).outcomer.name
    end
  end

  # GET /transaction_histories/1 or /transaction_histories/1.json
  def show
  end

  # GET /transaction_histories/new
  def new
    @transaction_history = TransactionHistory.new
    @transaction_history = TransactionHistory.new

    if params[:expenditure_id]
      @transaction_history.expenditure_id = params[:expenditure_id]
    elsif params[:income_id]
      @transaction_history.income_id = params[:income_id]
    end
  end

  # GET /transaction_histories/1/edit
  def edit
  end

  # POST /transaction_histories or /transaction_histories.json
  def create
    @transaction_history = TransactionHistory.new(transaction_history_params)
    @transaction_history.user_id = current_user.id
    respond_to do |format|
      if @transaction_history.save
        format.html { redirect_to main_page_path, notice: 'Успешно создано' }
        format.json { render :show, status: :created, location: @transaction_history }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @transaction_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /transaction_histories/1 or /transaction_histories/1.json
  def update
    respond_to do |format|
      if @transaction_history.update(transaction_history_params)
        format.html { redirect_to transaction_history_url(@transaction_history), notice: "Transaction history was successfully updated." }
        format.json { render :show, status: :ok, location: @transaction_history }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @transaction_history.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /transaction_histories/1 or /transaction_histories/1.json
  def destroy
    @transaction_history.destroy

    respond_to do |format|
      format.html { redirect_to transaction_histories_url, notice: "Transaction history was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_transaction_history
      @transaction_history = TransactionHistory.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def transaction_history_params
      params.require(:transaction_history).permit(:income_id, :expenditure_id, :amount)
    end
end
