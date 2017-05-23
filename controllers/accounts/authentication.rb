require 'sinatra'

# /api/v1/accounts authentication related routes
class TotodileAPI < Sinatra::Base
  post '/api/v1/accounts/authenticate' do
    content_type 'application/json'
    begin
      credentials = JSON.parse(request.body.read)
      account = AuthenticateAccount.call(credentials)
    rescue => e
      halt 500
      logger.info "Cannot authenticate #{credentials['name']}: #{e}"
    end

    account ? { account: account }.to_json : status(403)
  end
end
