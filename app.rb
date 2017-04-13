# frozen_string_literal: true
require 'sinatra'
require 'json'
require 'base64'
require_relative 'config/environment'
require_relative 'models/pokemon'
require_relative 'models/message'
require_relative 'models/user'
require_relative 'models/posting'

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

  # api about postings
  get '/api/v1/postings/?' do
    content_type 'application/json'
    JSON.pretty_generate(data: Posting.all)
  end

  post '/api/v1/postings/?' do
    content_type 'application/json'

    begin
      new_data = JSON.parse(request.body.read)
      new_message = Posting.new(new_data)
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


  # api about user
  get '/api/v1/users/?' do
    content_type 'application/json'
    JSON.pretty_generate(data: User.all)
  end

  post '/api/v1/users/?' do
    content_type 'application/json'

    begin
      post_data = JSON.parse(request.body.read)
      puts 'get POST data'
      puts post_data
      new_user = User.new(post_data)
      new_user.save
      # redirect '/api/v1/messages/' + new_user.uid + '.json'
    rescue => e
      logger.info "FAILED to create new user: #{e.inspect}"
      status 400
    end
  end
end
