class GuestInfosController < ApplicationController
  before_action :set_guest_info, only: %i[ show edit update destroy toggle_active ]

  # GET /guest_infos or /guest_infos.json
  def index
    @guest_infos = GuestInfo.all
    if params[:home_id].present?
      @guest_infos = Home.find(params[:home_id]).bookings.where(finished_at: nil).last.guest_infos
    end

    @guest_infos = @guest_infos.page(params[:page]).per(40)
  end

  # GET /guest_infos/1 or /guest_infos/1.json
  def show
  end

  # GET /guest_infos/new
  def new
    @guest_info = GuestInfo.new(booking_id: params[:booking_id])
  end

  # GET /guest_infos/1/edit
  def edit
  end

  # POST /guest_infos or /guest_infos.json
  def create
    @guest_info = GuestInfo.new(guest_info_params)

    respond_to do |format|
      if @guest_info.save
        if @guest_info.booking.number_of_people <= @guest_info.booking.guest_infos.count
          format.html { redirect_to homes_url(@guest_info), notice: "Guest info was successfully created." }
        else
          format.html { redirect_to new_guest_info_url(booking_id: @guest_info.booking.id), notice: "Guest info was successfully created." }
        end
        format.json { render :show, status: :created, location: @guest_info }
      else
        format.html { redirect_to request.referrer, notice: @guest_info.errors.messages }
        format.json { render json: @guest_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /guest_infos/1 or /guest_infos/1.json
  def update
    respond_to do |format|
      if @guest_info.update(guest_info_params)
        format.html { redirect_to guest_info_url(@guest_info), notice: "Guest info was successfully updated." }
        format.json { render :show, status: :ok, location: @guest_info }
      else
        format.html { redirect_to request.referrer, guest_info: @guest_info }
        format.json { render json: @guest_info.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /guest_infos/1 or /guest_infos/1.json
  def destroy
    @guest_info.destroy

    respond_to do |format|
      format.html { redirect_to guest_infos_url, notice: "Guest info was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def toggle_active
    @guest_info.update(avtive_guest: false)
    redirect_to request.referrer
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_guest_info
    @guest_info = GuestInfo.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def guest_info_params
    params.require(:guest_info).permit(:booking_id, :name, :phone_number, :country, :age)
  end
end
