# frozen_string_literal: true
require 'sinatra'
require 'json'

require_relative '../config/environment'

# Totodile web service
class TotodileAPI < Sinatra::Base
  get '/?' do
    'Totodile web API up at /api/v1'
  end
  
end