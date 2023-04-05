# app/controllers/devise/registrations_controller.rb
class Devise::RegistrationsController < DeviseController
  before_action :configure_sign_up_params, only: [:create]

  protected

  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
end
