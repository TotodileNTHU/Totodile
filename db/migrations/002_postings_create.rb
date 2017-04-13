# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:postings) do
      primary_key :id
      foreign_key :uid

      Time :created_time
      Time :updated_time
      String :message
      String :views
      String :type
    end
  end
end
