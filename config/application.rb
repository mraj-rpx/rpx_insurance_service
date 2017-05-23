require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module RpxInsuranceService
  class Application < Rails::Application
    config.autoload_paths << Rails.root.join('lib')
    require 'web_viewer_proxy'

    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.1

    # Initialize the foxit web viewer proxy
    # config.middleware.insert(0, WebViewerProxy)

    config.middleware.insert(0, Rack::ReverseProxy) do
      reverse_proxy_options preserve_host: true
      reverse_proxy(/^\/pc.*/, "http://#{ENV['WEB_VIEWER_HOST']}:#{ENV['WEB_VIEWER_PORT']}/")
      reverse_proxy(/^\/api.*/, "http://#{ENV['WEB_VIEWER_HOST']}:#{ENV['WEB_VIEWER_PORT']}/")
      reverse_proxy(/^\/asserts.*/, "http://#{ENV['WEB_VIEWER_HOST']}:#{ENV['WEB_VIEWER_PORT']}/")
      reverse_proxy(/^\/images.*/, "http://#{ENV['WEB_VIEWER_HOST']}:#{ENV['WEB_VIEWER_PORT']}/")
      reverse_proxy(/^\/scripts.*/, "http://#{ENV['WEB_VIEWER_HOST']}:#{ENV['WEB_VIEWER_PORT']}/")
      reverse_proxy(/^\/styles.*/, "http://#{ENV['WEB_VIEWER_HOST']}:#{ENV['WEB_VIEWER_PORT']}/")
      reverse_proxy(/^\/translation.*/, "http://#{ENV['WEB_VIEWER_HOST']}:#{ENV['WEB_VIEWER_PORT']}/")
    end
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.
  end
end
