# frozen_string_literal: true
require_relative 'spec_helper'

describe 'User spec' do
  it 'SAD: should not get invalid user' do
    get '/api/v1/users/' + SAD_USER_UID

    last_response.status.must_equal 200
    result = JSON.parse last_response.body
    result['data'].must_be_nil
  end

  it 'HAPPY: should create a new user and check if it already existed' do
    post '/api/v1/users',
    {uid: HAPPY_USER_UID1, name: HAPPY_USER_NAME1}.to_json,
    'CONTENT_TYPE' => 'application/json'

    last_response.status.must_equal 202
    User.count.must_be :>,0

    post '/api/v1/users',
    {uid: HAPPY_USER_UID1, name: HAPPY_USER_NAME2}.to_json,
    'CONTENT_TYPE' => 'application/json'

    last_response.status.must_equal 403
    last_response.body.must_equal 'user already existed'
  end
  
  it 'HAPPY: should get an existed user' do
    post '/api/v1/users',
    {uid: HAPPY_USER_UID2, name: HAPPY_USER_NAME2}.to_json,
    'CONTENT_TYPE' => 'application/json'

    get '/api/v1/users/' + HAPPY_USER_UID2

    last_response.status.must_equal 200
    result = JSON.parse last_response.body
    result['data']['name'].must_equal HAPPY_USER_NAME2
  end
end
