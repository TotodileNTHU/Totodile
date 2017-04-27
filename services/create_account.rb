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
			puts 'request_body ' + request_body
  	  account_representation = AccountRepresenter.new(Account.new)
  	  puts 'fuck account_representation'
			puts account_representation.from_json(request_body)
			Right(account_representation.from_json(request_body))
  	rescue
  	  Left(Error.new('Wrong input account data'))
  	end
  }

  register :check_if_already_exist, lambda { |data|
  	if Account.find(uid: data[:uid])
      Left(Error.new('This account already exist.'))
    else
      Right(data)
    end
  }

  register :write_to_account_table, lambda { |data|
		account = Account.create(
  		uid: data[:uid],
  		name: data[:name]
  	)
		account.password = data[:password]
		account.save
  	Right(account)
  }
end