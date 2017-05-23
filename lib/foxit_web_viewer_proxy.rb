require 'rack/proxy'

class FoxitWebViewerProxy < Rack::Proxy
  def perform_request(env)
    request = Rack::Request.new(env)

    if request.path =~ %r{^\/foxit}
      puts env['HTTP_HOST']
      puts env['SERVER_PORT']
      env['HTTP_HOST'] = ENV['WEB_VIEWER_HOST']
      env['SERVER_PORT'] = ENV['WEB_VIEWER_PORT']
      env['REQUEST_PATH'] = request.path.gsub('/foxit', '')
      byebug
      puts "AFTER CHANGE==========="
      puts env['HTTP_HOST']
      puts env['SERVER_PORT']
      super(env)
    else
      @app.call(env)
    end
  end
end
