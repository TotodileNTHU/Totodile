# frozen_string_literal: true

# Represents the account data
class AccountRepresenter < Roar::Decorator
  include Roar::JSON

  property :uid
  property :name
end
