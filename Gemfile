 #frozen_string_literal: true

source 'https://rubygems.org'
git_source(:github) { |repo| "https://github.com/#{repo}.git" }


# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '~> 5.2.1'

#database for active record
gem 'mysql2'

# Use SCSS for stylesheets
# since the theme is old, using older gems below
#gem 'sass-rails', '~> 5.0'

# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.2'
# Turbolinks makes navigating your web application faster. Read more: https://github.com/turbolinks/turbolinks
gem 'turbolinks', '~> 5'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.5'
# Use Redis adapter to run Action Cable in production
gem 'redis', '~> 4.0.1' # used for sidekiq
# Use ActiveModel has_secure_password
# gem 'bcrypt', '~> 3.1.7'
# Use jquery as the JavaScript library
gem 'jquery-rails'
gem 'jquery-ui-rails'


# Reduces boot times through caching; required in config/boot.rb
gem 'bootsnap', '>= 1.1.0', require: false

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'pry-rails'
  gem 'brakeman', '~> 4.2.1', require: false
  gem 'bundler-audit', require: false
  gem 'rspec-rails', '~> 3.7'
  gem 'spring'
  gem 'spring-watcher-listen', '~> 2.0.0'
end

group :test do
  gem 'capybara', '~> 2.15'
  gem 'chromedriver-helper'
  gem 'factory_bot_rails'
  gem 'faker'
  gem 'selenium-webdriver'
end

group :development do
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'capistrano',         require: false
  gem 'capistrano-chruby', require: false
  gem 'capistrano-rails', require: false
  gem 'capistrano-bundler', require: false
  gem 'capistrano-passenger', '~> 0.2.0'
  gem 'capistrano-faster-assets', '~> 1.0'
  gem 'capistrano-safe-deploy-to', '~> 1.1.1'
  gem 'capistrano-sidekiq'
  gem 'letter_opener'
  gem 'listen', '>= 3.0.5', '< 3.2'
  gem 'web-console'
end

# DSL changes
gem 'responders'


gem 'rails-jquery-autocomplete'

gem 'devise', '~> 4.4.3'

gem 'execjs', '1.4.0'
#gem 'bootstrap-sass', '~> 3.3.6'
gem 'sass-rails', '>= 3.2'
gem 'kaminari'


gem 'simple_form'
gem 'countries'
gem 'country_select'
gem 'validates_formatting_of'
gem 'bootstrap-datetimepicker-rails'

# For using simple_form as: :date_picker
#gem 'datetimepicker-rails', github: 'zpaulovics/datetimepicker-rails', branch: 'master', submodules: true
#gem 'momentjs-rails', '~> 2.9', github: 'derekprior/momentjs-rails'

gem 'paperclip', '~> 5.0.0.beta1'
#gem 'rmagick'
gem 'aws-sdk-s3', require: false

gem 'nested_scaffold'

gem 'cancancan', '~> 1.9'
gem 'role_model'

gem 'rails_admin'

# gem 'client_side_validations', github: 'DavyJonesLocker/client_side_validations', branch: 'rails5'
# gem 'client_side_validations-simple_form',github: 'DavyJonesLocker/client_side_validations-simple_form', branch: 'rails5'
# gem 'client_side_validations-simple_form'#, '~> 3.3', '>= 3.3.1'
# gem 'ruby-standard-deviation', '~> 2.0.0'
gem 'pdfkit'
gem 'wkhtmltopdf-binary'
gem 'string-urlize', '~> 1.0.2'
#gem 'protected_attributes_continued'
gem 'validates_email_format_of'


gem 'cocoon'
gem 'annotate'
gem 'sidekiq'
gem 'haml-rails'
gem 'acts-as-taggable-on', '~> 4.0'
