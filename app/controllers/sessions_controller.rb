class SessionsController < Devise::SessionsController
  def new
    if params[:role].blank?
      redirect_to roles_path, alert: 'Выберите роль, чтобы продолжить.'
    else
      @collection = User.where(active_user: true).where(role: params[:role].to_i).pluck(:name, :email)
      @role = params[:role]
      @users = User.where(role: @role)
      super
    end
  end

  def destroy
    super
  end

  def sign_out
    super # Remove the argument
    redirect_to roles_path
  end

end
