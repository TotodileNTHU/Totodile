# frozen_string_literal: true
require 'econfig'
require 'sinatra'
require 'json'

require_relative '../config/environment'

# Totodile web service
class TotodileAPI < Sinatra::Base
  extend Econfig::Shortcut

  configure do
    Econfig.env = settings.environment.to_s
    Econfig.root = File.expand_path('..', settings.root)

    SecureDB.setup(settings.config)
  end

  def secure_request?
    request.scheme.casecmp(settings.config.SECURE_SCHEME).zero?
  end

  before do
    halt(403, 'Use HTTPS only') unless secure_request?

    host_url = "#{settings.config.SECURE_SCHEME}://#{request.env['HTTP_HOST']}"
    @request_url = URI.join(host_url, request.path.to_s)
  end

  get '/?' do
    'Totodile web API up at /api/v1'
  end


end
