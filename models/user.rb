require 'sequel'
require 'json'
require 'base64'
require 'rbnacl/libsodium'

# frozen_string_literal: true

# Represents a User's stored information
class User < Sequel::Model
  one_to_many :postings

  def to_json(options = {})
    JSON({ type: 'user',
           uid: uid,
           name: name },
         options)
  end
end
