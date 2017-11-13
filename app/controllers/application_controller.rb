class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  before_action :configure_permitted_parameters, if: :devise_controller?
  
  protected
  
  def configure_permitted_parameters
    org_attrs = [:email, :password, :password_confirmation, :remember_me]
    added_attrs = [:first_name, :last_name, :username, :country]
    added_attrs << org_attrs
    
    devise_parameter_sanitizer.permit :sign_up, keys: added_attrs
    devise_parameter_sanitizer.permit :account_update, keys: added_attrs
  end
end
