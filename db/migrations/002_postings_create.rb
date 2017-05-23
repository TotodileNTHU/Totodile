# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:postings) do
      primary_key :id
      foreign_key :owner_id, :accounts

      String :uid
      String :content
      
      DateTime :created_at
      DateTime :updated_at
    end
  end
end
