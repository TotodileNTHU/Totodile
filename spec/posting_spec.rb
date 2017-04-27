# frozen_string_literal: true
require_relative 'spec_helper'

describe 'Posting spec' do
  it 'SAD: should not get posting with invalid uid' do
    get '/api/v1/postings?uid=' + SAD_ACCOUNT_UID
 
    result = JSON.parse last_response.body
    result['data'].must_equal 'none'
  end

  it 'SAD: should not get posting with invalid posting id' do
    get '/api/v1/postings?id=' + SAD_POSTING_ID
 
    result = JSON.parse last_response.body
    result['data'].must_equal 'none'
  end

  it 'SAD: should not create a new posting with invalid uid' do
    post '/api/v1/postings',
    {uid: SAD_ACCOUNT_UID, content: 'whatever'}.to_json,
    'CONTENT_TYPE' => 'application/json'

    last_response.status.must_equal 400
  end

  it 'HAPPY: should create a new posting then get the new posting' do
    # Create a new Posting with HAPPY_ACCOUNT_UID1
    post '/api/v1/postings',
    {uid: HAPPY_ACCOUNT_UID1, content: HAPPY_POSTING_CONTENT}.to_json,
    'CONTENT_TYPE' => 'application/json'

    Account.find(uid: HAPPY_ACCOUNT_UID1).postings.count.must_be :>,0

    # Find the Posting just created by uid = HAPPY_ACCOUNT_UID1
    get '/api/v1/postings?uid=' + HAPPY_ACCOUNT_UID1
 
    result = JSON.parse last_response.body
    result['data'].first['content'].must_equal HAPPY_POSTING_CONTENT
    
    # Find the Posting just created by id = Posting id
    id_tmp = Account.find(uid: HAPPY_ACCOUNT_UID1).postings.first.id
    get '/api/v1/postings?id=' + id_tmp.to_s
 
    result = JSON.parse last_response.body
    result['data'].first['content'].must_equal HAPPY_POSTING_CONTENT
  end
end
