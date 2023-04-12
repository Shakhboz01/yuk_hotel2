class BilletsController < ApplicationController
  before_action :set_billet, only: %i[ show edit update destroy ]

  # GET /billets or /billets.json
  def index
    @q = Billet.all.includes(:user)
    @billets = @q.result.page(params[:page]).per(40)
  end

  # GET /billets/1 or /billets/1.json
  def show
  end

  # GET /billets/new
  def new
    @billet = Billet.new
  end

  # GET /billets/1/edit
  def edit
  end

  # POST /billets or /billets.json
  def create
    @billet = Billet.new(billet_params)

    respond_to do |format|
      if @billet.save
        format.html { redirect_to billet_url(@billet), notice: "Billet was successfully created." }
        format.json { render :show, status: :created, location: @billet }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @billet.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /billets/1 or /billets/1.json
  def update
    respond_to do |format|
      if @billet.update(billet_params)
        format.html { redirect_to billet_url(@billet), notice: "Billet was successfully updated." }
        format.json { render :show, status: :ok, location: @billet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @billet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /billets/1 or /billets/1.json
  def destroy
    @billet.destroy

    respond_to do |format|
      format.html { redirect_to billets_url, notice: "Billet was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_billet
      @billet = Billet.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def billet_params
      params.require(:billet).permit(:user_id, :billet, :quantity, :waste_paper_proportion_id)
    end
end
