# frozen_string_literal: true
require 'sinatra'
require 'json'

class TotodileAPI < Sinatra::Base
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