class SessionsController < Devise::SessionsController
  include SsoAuthentication
  skip_before_action :check_or_login_using_token

  def create
    do_login
    super
  end

  def destroy
    if user_signed_in?
      sso_logout
    end
    super
  end
end