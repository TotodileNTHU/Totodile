# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:users) do
      primary_key :id
      String :uid
      String :name
    end
  end
end
