# frozen_string_literal: true
require 'sinatra'
require 'json'
require 'base64'
require_relative 'config/environment'
require_relative 'models/message'
require_relative 'models/user'
require_relative 'models/posting'

# Totodile web service
class TotodileAPI < Sinatra::Base
  configure do
    enable :logging
    Message.setup
  end

  get '/?' do
    'Totodile web API up at /api/v1'
  end

  # api about message
  get '/api/v1/messages/?' do
    content_type 'application/json'
    output = {message_id: Message.all}
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
      output = {message: Message.find(params[:id])}
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

  # get specific posting by uid or pid
  # '/api/v1/postings' List all postings
  # '/api/v1/postings?uid=john8787'
  # '/api/v1/postings?id=1'
  get '/api/v1/postings/?' do
    content_type 'application/json'

    begin
      subset = nil
      if !params[:uid].nil?
        puts 'uid'
        puts params[:uid]
        subset = Posting.where(uid: params[:uid])
      elsif !params[:id].nil?
        puts 'id'
        puts params[:id]
        subset = Posting.where(id: params[:id])
      else
        halt 200, JSON.pretty_generate(data: Posting.all)
      end

      result = []
      subset.each { |row| result.push(row) }
      if result.empty?
        JSON.pretty_generate(data: 'none')
      else
        JSON.pretty_generate(data: result)
      end

    rescue => e
      logger.info "FAILED to GET message: #{e.inspect}"
      status 404
    end
  end

  post '/api/v1/postings' do
    content_type 'application/json'

    begin
      new_data = JSON.parse(request.body.read)
      uid_found = User.find(uid: new_data['uid'])
      if uid_found
        new_post = Posting.new(new_data)
        if new_post.save
          logger.info "NEW MESSAGE STORED: #{new_post.id}"
          redirect '/api/v1/postings?id=' + new_post.id.to_s
        else
          halt 400, "Could not store message: #{new_post}"
        end
      else
        halt 400, 'invalid uid'
      end
    rescue => e
      logger.info "FAILED to create new message: #{e.inspect}"
      status 400
    end
  end


  # list all user
  get '/api/v1/users/?' do
    content_type 'application/json'
    JSON.pretty_generate(data: User.all)
  end

  # get user by id
  get '/api/v1/users/:uid' do
    content_type 'application/json'
    JSON.pretty_generate(data: User.find(uid: params[:uid]))
  end


  post '/api/v1/users/?' do
    content_type 'application/json'

    begin
      post_data = JSON.parse(request.body.read)
      puts 'get POST data'
      puts post_data
      if !User.find(uid: post_data['uid'])
        new_user = User.new(post_data)
        new_user.save
        status 202
      else
        halt 403, 'user already existed'
      end
    rescue => e
      logger.info "FAILED to create new user: #{e.inspect}"
      status 400
    end
  end
end
