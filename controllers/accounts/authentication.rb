require 'sinatra'

# /api/v1/accounts authentication related routes
class TotodileAPI < Sinatra::Base
  post '/api/v1/accounts/authenticate' do
    credentials = request.body.read
    result = AuthenticateAccount.call(credentials)
    
    if result.success?
      content_type 'application/json'
      result.value.to_json
    else
      ErrorRepresenter.new(result.value).to_status_response
    end
  end
end
