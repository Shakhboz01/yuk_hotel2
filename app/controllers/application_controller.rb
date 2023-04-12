class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  before_action :authenticate_user!

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  def after_sign_in_path_for(user)
    if user.менеджер?
      main_page_path
    elsif user.приёмщик?
      products_path
    elsif user.админ?
      dashboard_path
    elsif user.заготовщик?
      new_billet_path
    end
  end

  def after_sign_out_path_for(resource_or_scope)
    roles_path
  end

  private

  def user_not_authorized
    flash[:alert] = 'Вам не разрешено совершить эту операцию.'
    redirect_to(request.referrer || root_path)
  end

  def authenticate_user!
    super
    if current_user && !current_user.active_user
      sign_out current_user
    end
  end

  before_action :configure_permitted_parameters, if: :devise_controller?


  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up) { |u| u.permit(:name, :email, :password)}

    devise_parameter_sanitizer.permit(:account_update) { |u| u.permit(:name, :email, :password, :current_password)}
  end
end
