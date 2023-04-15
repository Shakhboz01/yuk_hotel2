class EndProductsController < ApplicationController
  before_action :set_end_product, only: %i[ show edit update destroy ]

  # GET /end_products or /end_products.json
  def index
    @end_products = EndProduct.all
  end

  # GET /end_products/1 or /end_products/1.json
  def show
  end

  # GET /end_products/new
  def new
    @end_product = EndProduct.new
  end

  # GET /end_products/1/edit
  def edit
  end

  # POST /end_products or /end_products.json
  def create
    @end_product = EndProduct.new(end_product_params)

    respond_to do |format|
      if @end_product.save
        format.html { redirect_to end_product_url(@end_product), notice: "End product was successfully created." }
        format.json { render :show, status: :created, location: @end_product }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @end_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /end_products/1 or /end_products/1.json
  def update
    respond_to do |format|
      if @end_product.update(end_product_params)
        format.html { redirect_to end_product_url(@end_product), notice: "End product was successfully updated." }
        format.json { render :show, status: :ok, location: @end_product }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @end_product.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /end_products/1 or /end_products/1.json
  def destroy
    @end_product.destroy

    respond_to do |format|
      format.html { redirect_to end_products_url, notice: "End product was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_end_product
      @end_product = EndProduct.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def end_product_params
      params.require(:end_product).permit(:amount_left, :name)
    end
end
