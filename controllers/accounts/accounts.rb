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
    post_data = request.body.read
    # puts 'api get post_data' + post_data
    result = CreateAccount.call(post_data)

    if result.success?
      content_type 'application/json'
      result.value.to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end

end