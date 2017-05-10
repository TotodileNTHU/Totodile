# frozen_string_literal: true

# Authenticate account
class AuthenticateAccount
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call(params)
    Dry.Transaction(container: self) do
      step :validate_request_json
      step :check_username_and_password_exist
    end.call(params)
  end

  register :validate_request_json, lambda {|request_body|
    begin
      json_data = JSON.parse(request_body)
      data = {uid: json_data['uid'], password: json_data['password']}
      Right(data)
    rescue
      Left(Error.new(:bad_request, 'Wrong input account data'))
    end
  }

  register :check_username_and_password_exist, lambda {|data|
    if Account.find(uid: data[:uid])
      account = Account.find(uid: data[:uid])
      if account.password?data[:password]
        Right(account)
      else
        Left(Error.new(:authenticate_error, 'Your username/password error.'))
      end
    else
      Left(Error.new(:authenticate_error, 'Your username/password is not correct.'))
    end
  }

end
