class SausagesController < ApplicationController
  before_action :set_sausage, only: %i[ show edit update destroy ]
  include Pundit
  # GET /sausages or /sausages.json
  def index
    authorize Sausage, :access?

    @q = Sausage.ransack(params[:q])
    @sausages = @q.result.includes(:user, :machine_size)
                  .order(id: :desc)

    if params.dig(:q, :created_at_gteq).blank? || params.dig(:q, :created_at_lteq).blank?
      today = Time.zone.today
      @sausages = Sausage.where(created_at: today.beginning_of_day..today.end_of_day)
                         .includes(:user, :machine_size).order(id: :desc)
    end

    @total_value = @sausages.sum { |sausage| sausage.machine_size.devision * sausage.quantity }
    @sausages = @sausages.page(params[:page]).per(40)
  end

  # GET /sausages/1 or /sausages/1.json
  def show
  end

  def operators_payment
    @operators = User.оператор.all
  end
  # GET /sausages/new
  def new
    authorize Sausage, :special_access?

    @sausage = Sausage.new
  end

  # GET /sausages/1/edit
  def edit
  end

  # POST /sausages or /sausages.json
  def create
    authorize Sausage, :special_access?

    @sausage = Sausage.new(sausage_params)
    @sausage.user_id = current_user.id

    if @sausage.save
      if current_user.оператор?
        redirect_to roles_path, notice: 'successfully created'
        sign_out current_user
        return
      end

      respond_to do |format|
          format.html { redirect_to sausages_url, notice: "successfully created." }
          format.json { render :show, status: :created, location: @sausage }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sausage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sausages/1 or /sausages/1.json
  def update
    authorize Sausage, :manage?

    respond_to do |format|
      if @sausage.update(sausage_params)
        format.html { redirect_to sausages_url, notice: "successfully updated." }
        format.json { render :show, status: :ok, location: @sausage }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sausage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sausages/1 or /sausages/1.json
  def destroy
    authorize Sausage, :manage?

    @sausage.destroy

    respond_to do |format|
      format.html { redirect_to sausages_url, notice: "successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_sausage
      @sausage = Sausage.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def sausage_params
      params.require(:sausage).permit(:user_id, :quantity)
    end
end
