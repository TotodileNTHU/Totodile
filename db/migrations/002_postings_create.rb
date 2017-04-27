# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:postings) do
      primary_key :id
      foreign_key :account_id
      
      String :uid
      String :content
      Time :created_time
    end
  end
end
