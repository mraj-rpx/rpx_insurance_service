class SessionsController < Devise::SessionsController
  include SsoAuthentication

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