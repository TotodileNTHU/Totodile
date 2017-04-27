# frozen_string_literal: true
require 'sinatra'
require 'json'

class TotodileAPI < Sinatra::Base
  # list all account
  get '/api/v1/accounts/?' do
    content_type 'application/json'
    JSON.pretty_generate(data: Account.all)
  end

  # get account by id
  get '/api/v1/accounts/:uid' do
    content_type 'application/json'
    JSON.pretty_generate(data: Account.find(uid: params[:uid]))
  end


  post '/api/v1/accounts/?' do
    content_type 'application/json'

    begin
      post_data = JSON.parse(request.body.read)
      if !Account.find(uid: post_data['uid'])
        new_account = Account.new(post_data)
        new_account.save
        status 202
      else
        halt 403, 'account already existed'
      end
    rescue => e
      logger.info "FAILED to create new account: #{e.inspect}"
      print('WTF')
      print(request.body.read)
      status 400
    end
  end
  
end