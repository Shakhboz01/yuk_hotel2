class OutcomerPrepaymentsController < ApplicationController
  include Pundit::Authorization
  before_action :set_outcomer_prepayment, only: %i[ show edit update destroy ]

  # GET /outcomer_prepayments or /outcomer_prepayments.json
  def index
    authorize OutcomerPrepayment, :access?

    @q = OutcomerPrepayment.ransack(params[:q])
    @outcomer_prepayments = @q.result.page(params[:page]).per(40)
  end

  # GET /outcomer_prepayments/1 or /outcomer_prepayments/1.json
  def show
  end

  # GET /outcomer_prepayments/new
  def new
    @outcomers = Outcomer.all
    @outcomer_prepayment = OutcomerPrepayment.new
  end

  # GET /outcomer_prepayments/1/edit
  def edit
    authorize OutcomerPrepayment, :manage?
    @outcomers = Outcomer.поставщик
  end

  # POST /outcomer_prepayments or /outcomer_prepayments.json
  def create
    authorize OutcomerPrepayment, :access?
    @outcomer_prepayment = OutcomerPrepayment.new(outcomer_prepayment_params)
    @outcomer_prepayment.user_id = current_user.id

    respond_to do |format|
      if @outcomer_prepayment.save
        format.html { redirect_to outcomer_prepayments_url, notice: "Outcomer prepayment was successfully created." }
        format.json { render :show, status: :created, location: @outcomer_prepayment }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @outcomer_prepayment.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /outcomer_prepayments/1 or /outcomer_prepayments/1.json
  def update
    authorize OutcomerPrepayment, :manage?

    respond_to do |format|
      if @outcomer_prepayment.update(outcomer_prepayment_params)
        format.html { redirect_to outcomer_prepayments_url, notice: "Outcomer prepayment was successfully updated." }
        format.json { render :show, status: :ok, location: @outcomer_prepayment }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @outcomer_prepayment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /outcomer_prepayments/1 or /outcomer_prepayments/1.json
  def destroy
    authorize OutcomerPrepayment, :manage?

    @outcomer_prepayment.destroy

    respond_to do |format|
      format.html { redirect_to outcomer_prepayments_url, notice: "Outcomer prepayment was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_outcomer_prepayment
      @outcomer_prepayment = OutcomerPrepayment.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def outcomer_prepayment_params
      params.require(:outcomer_prepayment).permit(:user_id, :outcomer_id, :price)
    end
end
