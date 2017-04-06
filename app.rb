# frozen_string_literal: true
require 'sinatra'
require 'json'
require 'base64'
require_relative 'models/pokemon'
require_relative 'models/message'

# Totodile web service
class TotodileAPI < Sinatra::Base
  configure do
    enable :logging
    Message.setup
    Pokemon.setup
  end

  get '/?' do
    'Totodile web API up at /api/v1'
  end

  # api about pokemon
  get '/api/v1/pokemons/?' do
    content_type 'application/json'
    output = { pokemon_id: Pokemon.all }
    JSON.pretty_generate(output)
  end

  get '/api/v1/pokemons/:id/description' do
    content_type 'text/plain'

    begin
      Pokemon.find(params[:id]).description
    rescue => e
      status 404
      e.inspect
    end
  end

  get '/api/v1/pokemons/:id.json' do
    content_type 'application/json'

    begin
      output = { pokemon: Pokemon.find(params[:id]) }
      JSON.pretty_generate(output)
    rescue => e
      logger.info "FAILED to GET pokemon: #{e.inspect}"
      status 404
    end
  end

  post '/api/v1/pokemons/?' do
    content_type 'application/json'

    begin
      new_data = JSON.parse(request.body.read)
      new_pokemon = Pokemon.new(new_data)
      if new_pokemon.save
        logger.info "NEW POKEMON STORED: #{new_pokemon.id}"
      else
        halt 400, "Could not store pokemon: #{new_pokemon}"
      end

      redirect '/api/v1/pokemons/' + new_pokemon.id + '.json'
    rescue => e
      logger.info "FAILED to create new pokemon: #{e.inspect}"
      status 400
    end
  end

  # api about message
  get '/api/v1/messages/?' do
    content_type 'application/json'
    output = { message_id: Message.all }
    JSON.pretty_generate(output)
  end

  get '/api/v1/messages/:id/content' do
    content_type 'text/plain'

    begin
      Message.find(params[:id]).content
    rescue => e
      status 404
      e.inspect
    end
  end

  get '/api/v1/messages/:id.json' do
    content_type 'application/json'

    begin
      output = { message: Message.find(params[:id]) }
      JSON.pretty_generate(output)
    rescue => e
      logger.info "FAILED to GET message: #{e.inspect}"
      status 404
    end
  end

  post '/api/v1/messages/?' do
    content_type 'application/json'

    begin
      new_data = JSON.parse(request.body.read)
      new_message = Message.new(new_data)
      if new_message.save
        logger.info "NEW MESSAGE STORED: #{new_message.id}"
      else
        halt 400, "Could not store message: #{new_message}"
      end

      redirect '/api/v1/messages/' + new_message.id + '.json'
    rescue => e
      logger.info "FAILED to create new message: #{e.inspect}"
      status 400
    end
  end
end
