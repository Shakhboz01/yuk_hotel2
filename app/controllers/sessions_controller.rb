class SessionsController < Devise::SessionsController
  def new
    if params[:role].blank?
      redirect_to roles_path, alert: 'Выберите роль, чтобы продолжить.'
    else
      @collection = User.where(active_user: true).where(role: params[:role].to_i).pluck(:name, :email)
      @role = params[:role]
      super
    end
  end
end
