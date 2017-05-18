# frozen_string_literal: true
require 'sequel'

Sequel.migration do
  change do
    create_table(:accounts) do
      primary_key :id
      String :uid, unique: true
      String :name, unique: true
      String :email
      String :password_hash, text: true
      String :salt
    end
  end
end
