# frozen_string_literal: true

# Represents the posting data
class PostingRepresenter < Roar::Decorator
  include Roar::JSON

  property :account_id
  property :uid
  property :content
end
