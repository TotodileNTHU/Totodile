# frozen_string_literal: true

# Represents a User's stored information
class User < Sequel::Model
  one_to_many :postings
end
