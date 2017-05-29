# frozen_string_literal: true
require 'json'
require 'sequel'

# Represents a Posting's stored information
class Posting < Sequel::Model
  many_to_one :owner, class: :Account
  set_allowed_columns :content,:uid,:created_time,:account_id

  plugin :timestamps, update_on_create: true

  def full_details
    { type: 'posting',
      id: id,
      attributes: {
        uid: uid,
        content: content
      },
      relationships: relationships }
  end

  def to_json(options = {})
    JSON({ type: 'posting',
           id: id,
           attributes: {
             uid: uid,
             content: content
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
