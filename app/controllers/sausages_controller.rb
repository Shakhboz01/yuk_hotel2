class SausagesController < ApplicationController
  before_action :set_sausage, only: %i[ show edit update destroy ]
  include Pundit

  def index
    authorize Sausage, :access?

    @q = Sausage.ransack(params[:q])
    @sausages = @q.result.includes(:user, :machine_size)
                  .order(id: :desc)
    @total_package = Package.ransack(params[:q]).result.sum(:quantity)
    today = Time.zone.today

    @total_value = @sausages.sum { |sausage| sausage.machine_size.devision * sausage.quantity }
    @sausages = @sausages.page(params[:page]).per(40)
  end

  def show
  end

  def operators_payment
    @operators = User.оператор.all
  end

  def new
    authorize Sausage, :special_access?

    @sausage = Sausage.new
  end

  def edit
  end

  def create
    authorize Sausage, :special_access?

    @sausage = Sausage.new(sausage_params)
    @sausage.user_id = current_user.id

    if @sausage.save
      if current_user.оператор?
        redirect_to roles_path, notice: 'Успешно создано'
        sign_out current_user
        return
      end

      respond_to do |format|
          format.html { redirect_to sausages_url, notice: "Успешно создано." }
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
        format.html { redirect_to sausages_url, notice: "Успешно обновлено." }
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
      format.html { redirect_to sausages_url, notice: "успешно удален." }
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
