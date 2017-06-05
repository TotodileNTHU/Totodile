# frozen_string_literal: true
require 'sinatra'
require 'json'

class TotodileAPI < Sinatra::Base
  # get account by id
  get '/api/v1/accounts/:id' do
    content_type 'application/json'

    id = params[:id]
    account = Account.where(id: id).first

    if account
      postings = account.owned_postings
      JSON.pretty_generate(data: account, relationships: postings)
    else
      halt 401, "ACCOUNT NOT VALID: #{id}"
    end
  end
  #create account
  post '/api/v1/accounts/?' do
    begin
      registration_info = JsonRequestBody.parse_symbolize(request.body.read)
      new_account = CreateAccount.call(registration_info)
    rescue => e
      logger.info "FAILED to create new account: #{e.inspect}"
      halt 400, "FAILED to create new account: #{e.inspect}"
    end

    new_location = URI.join(@request_url.to_s + '/', new_account.name).to_s

    status 201
    headers('Location' => new_location)
  end

end
