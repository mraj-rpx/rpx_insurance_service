class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ::SsoAuthentication

  before_action :skip_trackable
  before_action :check_or_login_using_token
  before_action :set_model_current_user

  def set_model_current_user
    User.current = current_user
  end
end
