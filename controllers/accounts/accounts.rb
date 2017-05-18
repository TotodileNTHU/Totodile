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
      projects = account.owned_projects
      JSON.pretty_generate(data: account, relationships: projects)
    else
      halt 401, "ACCOUNT NOT VALID: #{id}"
    end
  end

  # list all account
  # todo: should be removed?
  get '/api/v1/accounts/?' do
    content_type 'application/json'
    JSON.pretty_generate(data: Account.all)
  end

  post '/api/v1/accounts/?' do
    begin
      registration_info = JsonRequestBody.parse_symbolize(request.body.read)
      new_account = CreateAccount.call(registration_info)
    rescue => e
      logger.info "FAILED to create new account: #{e.inspect}"
      halt 400
    end

    new_location = URI.join(@request_url.to_s + '/', new_account.username).to_s

    status 201
    headers('Location' => new_location)
  end

end
