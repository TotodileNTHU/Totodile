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
    begin
      json_str = request.body.read
      registration_info = JSON.parse(json_str, symbolize_names: true)
      new_account = CreateAccount.call(registration_info)
    rescue => e
      logger.info "FAILED to create new account: #{e.inspect}"
      halt 400
    end

    new_location = URI.join(@request_url.to_s + '/', new_account.name).to_s

    status 201
    headers('Location' => new_location)
  end

end