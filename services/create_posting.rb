# frozen_string_literal: true
require_relative '../lib/secure_db'
require 'base64'
require 'rbnacl/libsodium'

# Create a new posting
class CreatePosting
  def self.call(params)
    account = Account.find(uid: params[:uid])
    if account
      key = [SecureDB.config.DB_KEY].pack('H*')
      box = RbNaCl::SimpleBox.from_secret_key(key)
      result = Posting.create(
          account_id: account.id,
          uid:  params[:uid],
          content: Base64.strict_encode64(box.encrypt(params[:content])),
          created_time: Time.now
      )
      result
    else
      nil
    end
  end
end