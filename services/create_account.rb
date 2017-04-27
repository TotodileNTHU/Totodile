# frozen_string_literal: true

# Create a new account
class CreateAccount
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call(params)
  	Dry.Transaction(container: self) do
  	  step :validate_request_json
  	  step :check_if_already_exist
  	  step :write_to_account_table
  	end.call(params)
  end

  register :validate_request_json, lambda { |request_body|
  	begin
  	  account_representation = AccountRepresenter.new(Account.new)
  	  Right(account_representation.from_json(request_body))
  	rescue
  	  Left(Error.new(:bad_request, 'Wrong input account data'))
  	end
  }

  register :check_if_already_exist, lambda { |data|
  	if Account.find(uid: data[:uid])
      Left(Error.new(:bad_request, 'This account already exist.'))
    else
      Right(data)
    end
  }

  register :write_to_account_table, lambda { |data|
  	result = Account.create(
  			   uid: data[:uid],
  			   name: data[:name]
  		     )
  	Right(result)
  }
end