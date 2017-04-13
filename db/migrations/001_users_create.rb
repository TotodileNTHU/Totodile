# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:users) do
      primary_key :uid
      String :uid
      String :name
    end
  end
end
