require 'sequel'
require 'json'
require 'base64'
require 'rbnacl/libsodium'

# frozen_string_literal: true

# Represents a Account's stored information
class Account < Sequel::Model
  set_allowed_columns :username, :email
  one_to_many :postings

  def password=(new_password)
    new_salt = SecureDB.new_salt
    hashed = SecureDB.hash_password(new_salt, new_password)
    self.salt = new_salt
    self.password_hash = hashed
  end

  def password=(new_password)
    new_salt = SecureDB.new_salt
    hashed = SecureDB.hash_password(new_salt, new_password)
    self.salt = new_salt
    self.password_hash = hashed
  end

  def password?(try_password)
    try_hashed = SecureDB.hash_password(salt, try_password)
    try_hashed == password_hash
  end

  def to_json(options = {})
    JSON({ type: 'account',
           uid: uid,
           email: email,
           username: username},
         options)
  end
end
