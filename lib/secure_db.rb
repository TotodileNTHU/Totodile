require 'sinatra'
require 'econfig'

class SecureDB < Sinatra::Base

  extend Econfig::Shortcut
  Econfig.env = settings.environment.to_s
  Econfig.root = File.expand_path('../', settings.root)

end