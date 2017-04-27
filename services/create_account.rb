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

  register :validate_request_json, lambda {|request_body|
    begin
      json_data = JSON.parse(request_body)
      data = {uid: json_data['uid'], name: json_data['name']}
      # S_Account is the value object in /values/account.rb
      # account_representation = AccountRepresenter.new(S_Account.new)
      # puts 'fuck account_representation'
      # puts account_representation.from_json(request_body)
      # Right(account_representation.from_json(request_body))
      Right(data)
    rescue
      Left(Error.new('Wrong input account data'))
    end
  }

  register :check_if_already_exist, lambda {|data|
    puts 'check_if_already_exist ' + data.to_s
    if Account.find(uid: data[:uid])
      puts 'Left(Error.This account already exist.'
      Left(Error.new('This account already exist.'))
    else
      Right(data)
    end
  }

  register :write_to_account_table, lambda {|data|
    puts 'write_to_account_table'
    account = Account.create(
        uid: data[:uid],
        name: data[:name],
        password_hash: '',
        salt: '',
    )
    account.password = '94788'
    account.save
    Right(account)
  }
end