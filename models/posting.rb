# frozen_string_literal: true

# Represents a Posting's stored information
class Posting < Sequel::Model
  many_to_one :user

  def to_json(options = {})
    JSON({ type: 'posting',
           id: id,
           uid: uid,
           content: content,
           created_time: created_time },
         options)
  end
end
