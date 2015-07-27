source 'https://rubygems.org'
ruby "2.2.2"

# For Neo4j graph database
gem 'neo4j', '~> 5.0.0'
# Postgres
gem 'pg'
# Sinatra
gem 'sinatra', '1.1.0'
# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.2'
#
gem 'rails_12factor', group: :production
# Use puma as webserver 
gem 'puma', group: :production
# Bootstrap
gem 'bootstrap-sass', '3.2.0.0'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use CoffeeScript for .coffee assets and views
gem 'coffee-rails', '~> 4.1.0'
# See https://github.com/rails/execjs#readme for more supported runtimes
# gem 'therubyracer', platforms: :ruby
#for getting country code
gem 'countries', :require => 'iso3166'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Turbolinks makes following links in your web application faster. Read more: https://github.com/rails/turbolinks
gem 'turbolinks'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc

gem 'carrierwave'
gem 'carrierwave-neo4j', require: 'carrierwave/neo4j'
gem 'cloudinary'
gem "mini_magick", "~> 4.2.7"
gem 'rmagick', '~> 2.15.2'
gem 'simple_form'
gem 'paperclip'
gem "neo4jrb-paperclip", :require => "neo4jrb_paperclip"
gem "aws-s3",            :require => "aws/s3"

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'
# For creatind sample users in the db
gem 'faker', '1.4.2'
# For pagination method
gem 'neo4j-will_paginate_redux'
# For configuring will_paginate to use Bootstrap’s pagination styles
gem 'bootstrap-will_paginate', '0.0.10'
# For selecting countries in user forms
gem 'country_select', github: 'stefanpenner/country_select'
# For date pickers
#gem 'bootstrap-datepicker-rails'
#for date validation
gem 'validates_timeliness', '~> 3.0'

# Use Unicorn as the app server
# gem 'unicorn'

# Use Capistrano for deployment
# gem 'capistrano-rails', group: :development

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'

  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'

  # Spring speeds up development by keeping your application running in the background. Read more: https://github.com/rails/spring
  gem 'spring'
  gem 'log_buddy'
end

group :test do
  gem 'minitest-reporters', '1.0.5'
  gem 'mini_backtrace',     '0.1.3'
  gem 'guard-minitest',     '2.3.1'
end

group :development do
	gem 'thin'
end

