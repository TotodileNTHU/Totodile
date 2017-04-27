require 'sequel'
require 'json'
require 'base64'
require 'rbnacl/libsodium'

# frozen_string_literal: true

# Represents a Account's stored information
class Account < Sequel::Model
  one_to_many :postings

  def to_json(options = {})
    JSON({ type: 'account',
           uid: uid,
           name: name },
         options)
  end
end
