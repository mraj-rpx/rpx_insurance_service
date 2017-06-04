# Module that contains the functions that related to the SSO Authentication
module SsoAuthentication

  def skip_trackable
    request.env['devise.skip_trackable'] = true
  end

  def generate_body
    body = { grant_type: 'password' }
    if request[:user]
      body[:login] = request[:user][:email] || params[:user][:email]
      body[:password] = request[:user][:password]
      body[:remember_me] = request[:user][:remember_me]
    end

    body
  end

  def generate_headers
    header = {
      'REQUEST-USER-AGENT' => request.user_agent,
      'REQUEST-FROM-IP' => remote_ip,
      'BROWSER-SESSION-TOKEN' => (defined?(cookies) && cookies[auth_session_identifier] ?  cookies[auth_session_identifier] : ""),
      'APP-ID' => ENV['AUTH_APP_ID']
    }
    if session[:authorizer_token]
      header['Authorization'] = 'Bearer ' + session[:authorizer_token]
    end
    header
  end

  def sso_login
    HTTParty.post(
      ENV['AUTHENTICATOR_SERVER_ADDRESS'] + '/oauth/token',
      body: generate_body,
      headers: generate_headers
    )
  end

  def sso_logout
    HTTParty.delete(ENV['AUTHENTICATOR_SERVER_ADDRESS'] + '/api/clear_session',
                    headers:  generate_headers)
  end

  def sso_login_check
    HTTParty.get(
      ENV['AUTHENTICATOR_SERVER_ADDRESS'] + '/api/check_login',
      headers: generate_headers
    )
  end

  def remote_ip
    (request.env['HTTP_X_FORWARDED_FOR'] || request.remote_ip).split(',').first
  end

  def clear_session
    session[:authorizer_login] = false
    session[:authorizer_token] = nil
    cookies.delete(auth_session_identifier, domain: ENV['AUTH_COOKIE_DOMAIN'])
    session[:auth_session_id] = nil
  end

  def app_sign_out
    clear_session
    sign_out_and_redirect(current_user) unless current_user
  end

  def set_session_cookie(response)
    cookies[auth_session_identifier] = {
      value: response['session_key'],
      expires: 1.year.from_now,
      domain: ENV['AUTH_COOKIE_DOMAIN']
    }
    session[:authorizer_token] = response['access_token']
    session[:authorizer_login] = true
    session[:auth_session_id] = response['session_key']
  end

  def app_login(response)
    sign_out(current_user) if current_user && !defined? @token
    user = User.where(email: response['user']['email']).first
    set_session_cookie(response)
    sign_in_args = []
    sign_in_args << user
    clear_session unless user && user.confirmed?
    sign_in(*sign_in_args) if user
  end

  def do_login
    response = sso_login
    response_con = (response != 'Invalid Login or password.' &&
                    response.code == 200)
    response_con ? app_login(response) : app_sign_out
  end

  def check_or_login_using_token
    do_login if cookies[auth_session_identifier].present? &&
                (!user_signed_in? ||
                 cookies[auth_session_identifier] != session[:auth_session_id])
    app_sign_out unless (session[:authorizer_login] && session[:authorizer_token]) &&
                       sso_login_check.code == 200
  end

  def auth_session_identifier
    ("_auth_session_identifier" + (Rails.env != "production" ? "_#{Rails.env}" : "")).to_sym
  end
end