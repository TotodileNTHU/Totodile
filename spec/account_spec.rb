# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Account spec' do
  it 'SAD: should not get invalid account' do
    get '/api/v1/accounts/' + SAD_ACCOUNT_UID

    last_response.status.must_equal 200
    result = JSON.parse last_response.body
    result['data'].must_be_nil
  end

  it 'HAPPY: should create a new account and check if it already existed' do
    # Create a new Account
    post '/api/v1/accounts',
    {uid: HAPPY_ACCOUNT_UID1, name: HAPPY_ACCOUNT_NAME1}.to_json,
    'CONTENT_TYPE' => 'application/json'

    last_response.status.must_equal 200
    Account.count.must_be :>,0

    # Create a new Account with the same uid
    post '/api/v1/accounts',
    {uid: HAPPY_ACCOUNT_UID1, name: HAPPY_ACCOUNT_NAME2}.to_json,
    'CONTENT_TYPE' => 'application/json'

    last_response.status.must_equal 400
  end
  
  it 'HAPPY: should get an existed account' do
    post '/api/v1/accounts',
    {uid: HAPPY_ACCOUNT_UID2, name: HAPPY_ACCOUNT_NAME2}.to_json,
    'CONTENT_TYPE' => 'application/json'

    get '/api/v1/accounts/' + HAPPY_ACCOUNT_UID2

    last_response.status.must_equal 200
    result = JSON.parse last_response.body
    result['data']['name'].must_equal HAPPY_ACCOUNT_NAME2
  end
end
