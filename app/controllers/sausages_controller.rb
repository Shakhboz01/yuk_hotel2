class SausagesController < ApplicationController
  before_action :set_sausage, only: %i[ show edit update destroy ]

  # GET /sausages or /sausages.json
  def index
    @sausages = Sausage.all
  end

  # GET /sausages/1 or /sausages/1.json
  def show
  end

  # GET /sausages/new
  def new
    @sausage = Sausage.new
  end

  # GET /sausages/1/edit
  def edit
  end

  # POST /sausages or /sausages.json
  def create
    @sausage = Sausage.new(sausage_params)

    respond_to do |format|
      if @sausage.save
        format.html { redirect_to sausage_url(@sausage), notice: "Sausage was successfully created." }
        format.json { render :show, status: :created, location: @sausage }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @sausage.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /sausages/1 or /sausages/1.json
  def update
    respond_to do |format|
      if @sausage.update(sausage_params)
        format.html { redirect_to sausage_url(@sausage), notice: "Sausage was successfully updated." }
        format.json { render :show, status: :ok, location: @sausage }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @sausage.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /sausages/1 or /sausages/1.json
  def destroy
    @sausage.destroy

    respond_to do |format|
      format.html { redirect_to sausages_url, notice: "Sausage was successfully destroyed." }
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
