require 'rack/proxy'

class WebViewerProxy < Rack::Proxy
  def initialize(app, *args)
    @app = app
  end

  def call(env)
    original_host = env['HTTP_HOST']
    rewrite_env(env)
binding.pry
    if env['HTTP_HOST'] != original_host
      rr = perform_request(env)
      binding.pry
      rr
    else
      rr = @app.call(env)
      binding.pry
      rr
    end
  end

  def rewrite_env(env)
    request = Rack::Request.new(env)
binding.pry
    if request.path =~ %r{^\/(api|styles|images|scripts)}
      env['HTTP_HOST'] = ENV['WEB_VIEWER_HOST']
      env['SERVER_PORT'] = ENV['WEB_VIEWER_PORT']
      # env['REQUEST_URI'] = request.path.gsub('/foxit', '')
      # env['REQUEST_PATH'] = request.path.gsub('/foxit', '')
      # env['PATH_INFO'] = 'http://172.17.2.184:8081/pc/my_viewer.html'
    end
    env
  end
end
