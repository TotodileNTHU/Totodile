# frozen_string_literal: true

# Represents the posting data
class CommentRepresenter < Roar::Decorator
  include Roar::JSON

  property :commenter
  property :content
  property :created_time
end
