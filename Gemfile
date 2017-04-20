# frozen_string_literal: true
source 'https://rubygems.org'
ruby '2.4.0'

gem 'json'
gem 'puma'
gem 'rbnacl-libsodium'
gem 'sinatra'

gem 'sequel'

gem 'tux'
gem 'hirb'
gem 'econfig'


group :development do
  gem 'rerun'

  gem 'flog'
  gem 'flay'
end

group :test do
  gem 'minitest'
  gem 'minitest-rg'

  gem 'rack-test'

  gem 'vcr'
  gem 'webmock'
end

group :development, :test do
  gem 'sqlite3'
end

group :production do
  gem 'pg'
end
