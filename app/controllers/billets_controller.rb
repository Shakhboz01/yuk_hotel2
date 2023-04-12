class BilletsController < ApplicationController
  include Pundit

  before_action :set_billet, only: %i[ show edit update destroy ]

  def index
    authorize Billet, :manage?

    @q = Billet.ransack(params[:q])
    @billets = @q.result.includes(:user, :waste_paper_proportion).page(params[:page]).per(40)
  end

  def show
  end

  def new
    authorize Billet, :access?

    @billet = Billet.new
  end

  def edit
    authorize Billet, :manage?
  end

  def create
    authorize Billet, :access?

    @billet = Billet.new(billet_params)
    @billet.user = current_user

    if @billet.save
      BilletCrudOperation.run(
        quantity: @billet.quantity,
        waste_paper_proportion: @billet.waste_paper_proportion
      )

      respond_to do |format|
        format.html { redirect_to billets_path, notice: "Заготовка успешно создана." }
        format.json { render :show, status: :created, location: @billet }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @billet.errors, status: :unprocessable_entity }
      end
    end
  end

  def update
    authorize Billet, :manage?

    respond_to do |format|
      if @billet.update(billet_params)
        format.html { redirect_to billets_path, notice: "Заготовка успешно обновлена." }
        format.json { render :show, status: :ok, location: @billet }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @billet.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /billets/1 or /billets/1.json
  def destroy
    authorize Billet, :admin?

    @billet.destroy

    respond_to do |format|
      format.html { redirect_to billets_url, notice: "Заготовка была успешно уничтожена." }
      format.json { head :no_content }
    end
  end


  private

  def set_billet
    @billet = Billet.find(params[:id])
  end

  def billet_params
    params.require(:billet).permit(:user_id, :billet, :quantity, :waste_paper_proportion_id)
  end
end
