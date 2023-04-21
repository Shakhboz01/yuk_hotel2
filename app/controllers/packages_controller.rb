class PackagesController < ApplicationController
  before_action :set_package, only: %i[ show edit update destroy ]
  include Pundit

  # GET /packages or /packages.json
  def index
    authorize Package, :access?
    @q = Package.ransack(params[:q])
    @packages = @q.result.order(id: :desc).page(params[:page]).per(40)
  end

  # GET /packages/1 or /packages/1.json
  def show
  end

  # GET /packages/new
  def new
    authorize Package, :special_access?

    @package = Package.new
  end

  def new_package
    authorize Package, :special_access?

    PackageCrudOperation.run(
      data: params[:new_package].permit!.to_h.to_a, user_id: current_user.id
    )
    if current_user.упаковщик?
      redirect_to roles_path
      sign_out current_user
    else
      redirect_to packages_path, notice: 'успешно создано'
    end
  end

  # GET /packages/1/edit
  def edit
    authorize Package, :access?
  end

  # POST /packages or /packages.json
  def create
    authorize Package, :special_access?
    @package = Package.new(package_params)

    if @package.save
      respond_to do |format|
        format.html { redirect_to packages_url, notice: "Успешно создано." }
        format.json { render :show, status: :created, location: @package }
      end
    else
      respond_to do |format|
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /packages/1 or /packages/1.json
  def update
    authorize Package, :manage?

    respond_to do |format|
      if @package.update(package_params)
        format.html { redirect_to packages_url, notice: "Успешно обновлено." }
        format.json { render :show, status: :ok, location: @package }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @package.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /packages/1 or /packages/1.json
  def destroy
    authorize Package, :manage?

    @package.destroy

    respond_to do |format|
      format.html { redirect_to packages_url, notice: "Package was успешно удален." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_package
      @package = Package.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def package_params
      params.require(:package).permit(:product_id, :user_id, :quantity)
    end
end
