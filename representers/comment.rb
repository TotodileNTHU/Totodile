# frozen_string_literal: true

# Represents the posting data
class CommentRepresenter < Roar::Decorator
  include Roar::JSON

  property :commenter_name
  property :commenter_id
  property :content
  property :created_time
end
