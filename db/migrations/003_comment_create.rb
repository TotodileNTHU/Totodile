# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:comments) do
      primary_key :id
      foreign_key :owner_id, :postings

      String :commenter
      String :content

      DateTime :created_at
    end
  end
end
