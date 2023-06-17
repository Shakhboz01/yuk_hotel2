class MachineSizesController < ApplicationController
  before_action :set_machine_size, only: %i[ show edit update destroy ]
  include Pundit::Authorization
  # GET /machine_sizes or /machine_sizes.json
  def index
    authorize MachineSize, :access?

    @machine_sizes = MachineSize.all
  end

  # GET /machine_sizes/1 or /machine_sizes/1.json
  def show
  end

  # GET /machine_sizes/new
  def new
    authorize MachineSize, :access?

    @machine_size = MachineSize.new
  end

  # GET /machine_sizes/1/edit
  def edit
  end

  # POST /machine_sizes or /machine_sizes.json
  def create
    authorize MachineSize, :manage?

    @machine_size = MachineSize.new(machine_size_params)

    respond_to do |format|
      if @machine_size.save
        format.html { redirect_to machine_sizes_url, notice: "Успешно создано." }
        format.json { render :show, status: :created, location: @machine_size }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @machine_size.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /machine_sizes/1 or /machine_sizes/1.json
  def update
    authorize MachineSize, :manage?

    respond_to do |format|
      if @machine_size.update(machine_size_params)
        format.html { redirect_to machine_sizes_url, notice: "Успешно обновлено." }
        format.json { render :show, status: :ok, location: @machine_size }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @machine_size.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /machine_sizes/1 or /machine_sizes/1.json
  def destroy
    authorize MachineSize, :manage?

    @machine_size.destroy

    respond_to do |format|
      format.html { redirect_to machine_sizes_url, notice: "успешно удален." }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_machine_size
      @machine_size = MachineSize.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def machine_size_params
      params.require(:machine_size).permit(:user_id, :devision)
    end
end
