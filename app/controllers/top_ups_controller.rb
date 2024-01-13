class TopUpsController < ApplicationController
  before_action :set_top_up, only: %i[ show edit update destroy ]

  # GET /top_ups or /top_ups.json
  def index
    @q = TopUp.ransack(params[:q])
    @top_ups = @q.result.order(created_at: :desc)
    if params[:home_id].present?
      @top_ups = Home.find(params[:home_id]).bookings.where(finished_at: nil).last.top_ups
    end
    @all_top_ups = @top_ups
    @top_ups = @top_ups.page(params[:page]).per(40)
  end

  # GET /top_ups/1 or /top_ups/1.json
  def show
  end

  # GET /top_ups/new
  def new
    booking = Home.find(params[:home_id]).bookings.where(finished_at: nil).last
    @top_up = TopUp.new(booking_id: booking.id)
    @guest_infos = booking.guest_infos.where(avtive_guest: true).pluck(:name, :id)
  end

  # GET /top_ups/1/edit
  def edit
  end

  # POST /top_ups or /top_ups.json
  def create
    @top_up = TopUp.new(top_up_params)

    respond_to do |format|
      if @top_up.save
        format.html { redirect_to homes_url, notice: "Top up was successfully created." }
        format.json { render :show, status: :created, location: @top_up }
      else
        format.html { redirect_to request.referrer }
        format.json { render json: @top_up.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /top_ups/1 or /top_ups/1.json
  def update
    respond_to do |format|
      if @top_up.update(top_up_params)
        format.html { redirect_to top_up_url(@top_up), notice: "Top up was successfully updated." }
        format.json { render :show, status: :ok, location: @top_up }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @top_up.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /top_ups/1 or /top_ups/1.json
  def destroy
    @top_up.destroy

    respond_to do |format|
      format.html { redirect_to top_ups_url, notice: "Top up was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_top_up
    @top_up = TopUp.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def top_up_params
    params.require(:top_up).permit(:guest_info_id, :booking_id, :price, :comment, :created_at, :payment_type)
  end
end
