class ShiftsController < ApplicationController
  before_action :set_shift, only: %i[ show edit update destroy ]

  # GET /shifts or /shifts.json
  def index
    @q = Shift.ransack(params[:q])
    @shifts = @q.result.order(id: :desc)
    @all_shifts = @shifts
    @shifts = @shifts.page(params[:page]).per(40)
  end

  # GET /shifts/1 or /shifts/1.json
  def show
  end

  # GET /shifts/new
  def new
    @shift = Shift.new
  end

  # GET /shifts/1/edit
  def edit
  end

  # POST /shifts or /shifts.json
  def create
    @shift = Shift.new(shift_params)
    @shift.user = current_user

    respond_to do |format|
      if @shift.save
        format.html { redirect_to request.referrer, notice: "Смена открыт" }
        format.json { render :show, status: :created, location: @shift }
      else
        format.html { redirect_to request.referrer, notice: "Error" }
        format.json { render json: @shift.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /shifts/1 or /shifts/1.json
  def update
    respond_to do |format|
      if @shift.update(shift_params)
        format.html { redirect_to shift_url(@shift), notice: "Shift was successfully updated." }
        format.json { render :show, status: :ok, location: @shift }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @shift.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /shifts/1 or /shifts/1.json
  def destroy
    @shift.destroy

    respond_to do |format|
      format.html { redirect_to shifts_url, notice: "Shift was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def toggle
    if !(shift = Shift.unclosed.last).nil? && shift&.user_id == current_user.id
      shift.update!(closed_at: DateTime.current)
      sign_out current_user
    elsif Shift.unclosed.last.nil?
      Shift.create(user: current_user)
    end

    redirect_to request.referrer
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_shift
    @shift = Shift.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def shift_params
    params.require(:shift).permit(:user_id, :closed_at, :total_income, :total_expenditure)
  end
end
