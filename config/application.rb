# frozen_string_literal: true

require_relative 'boot'

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

require 'pdfkit'

module Erp
  class Application < Rails::Application
    # Initialize configuration defaults for originally generated Rails version.
    config.load_defaults 5.2

    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration can go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded after loading
    # the framework and any gems in your application.

    # Use the responders controller from the responders gem
    config.app_generators.scaffold_controller :responders_controller
    config.time_zone = 'Eastern Time (US & Canada)'

    config.active_job.queue_adapter = :sidekiq

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    config.i18n.default_locale = :en

  

    # Configure sensitive parameters which will be filtered from the log file.
    #config.filter_parameters += [:password]

    # Enable escaping HTML in JSON.
    config.active_support.escape_html_entities_in_json = true

    # Use SQL instead of Active Record's schema dumper when creating the database.
    # This is necessary if your schema can't be completely dumped by the schema dumper,
    # like if you have constraints or database-specific column types
    # config.active_record.schema_format = :sql
    # Enforce whitelist mode for mass assignment.
    # This will create an empty whitelist of attributes available for mass-assignment for all models
    # in your app. As such, your models will need to explicitly whitelist or blacklist accessible
    # parameters by using an attr_accessible or attr_protected declaration.
    # config.active_record.whitelist_attributes = true

    config.middleware.use PDFKit::Middleware, print_media_type: true

    config.generators do |g|
      g.helper false
      g.javascripts false
      g.jbuilder = false
      g.stylesheets false
      g.system_tests = nil

      g.test_framework :rspec,
                       fixtures: true,
                       controller_specs: false,
                       helper_specs: false,
                       model_specs: true,
                       request_specs: false,
                       routing_specs: false,
                       view_specs: false
      g.fixture_replacement :factory_bot, dir: 'spec/factories'
    end
  end
end
