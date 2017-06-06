# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:comments) do
      primary_key :id
      foreign_key :posting_id, :postings

      String :commenter_id
      String :commenter_name
      String :content

      DateTime :created_at
    end
  end
end
