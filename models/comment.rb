# frozen_string_literal: true
require 'json'
require 'sequel'

# Represents a Posting's stored information
class Comment < Sequel::Model
  many_to_one :owner, class: :Posting   #owner here means the posting which has this comment

  plugin :timestamps, update_on_create: true

  def full_details
    { type: 'comment',
      id: id,
      attributes: {
        commenter: commenter,
        content: content,
        created_at: created_at
      },
      relationships: relationships }
  end

  def to_json(options = {})
    JSON({ type: 'comment',
           id: id,
           attributes: {
             commenter: commenter,
             content: content,
             created_at: created_at
           },
           relationships: {
              owner: owner
           }
         },
        options)
  end

  private

  def relationships
    {
      owner: owner
    }
  end

end
