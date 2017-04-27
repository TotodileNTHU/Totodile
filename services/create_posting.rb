# frozen_string_literal: true
require_relative '../lib/secure_db'
require 'base64'
require 'rbnacl/libsodium'


# Create a new posting
class CreatePosting
  extend Dry::Monads::Either::Mixin
  extend Dry::Container::Mixin

  def self.call(params)
  	Dry.Transaction(container: self) do
      step :check_uid_exist
  	  step :write_to_posting_table
  	end.call(params)
  end

  register :check_uid_exist, lambda { |request_body|
    uid = request_body['uid']
    account = Account.find(uid: uid)
    if account
      key = [SecureDB.config.DB_KEY].pack('H*')
      box = RbNaCl::SimpleBox.from_secret_key(key)
      data = {
        account_id: account.id,
        uid: uid,
        content: Base64.strict_encode64(box.encrypt(request_body['content'])),
        created_time: Time.now 
      }
      Right(data)
    else
      Left(Error.new(:bad_request, 'invalid uid'))
    end
  }

  register :write_to_posting_table, lambda { |data|
    result = Posting.create(
      account_id: data[:account_id],
      uid: data[:uid],
      content: data[:content],
      created_time: data[:created_time]
    )
    Right(result)
  }

end