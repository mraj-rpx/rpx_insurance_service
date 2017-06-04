class ApplicationController < ActionController::Base
  protect_from_forgery with: :exception
  include ::SsoAuthentication

  before_filter :skip_trackable
  before_filter :check_or_login_using_token
end
