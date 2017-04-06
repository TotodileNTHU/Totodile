# frozen_string_literal: true
require 'sinatra'
require 'json'
require 'base64'
require_relative 'models/pokemon'

# Totodile web service
class TotodileAPI < Sinatra::Base
  get '/?' do
  	'Totodile web API up at /api/v1'
  end

  get '/api/v1/pokemons/?' do
  	content_type 'application/json'
  	output = { pokemon_id: Pokemon.all }
  	JSON.pretty_generate(output)
  end
end