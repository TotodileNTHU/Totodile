# frozen_string_literal: true
require_relative './spec_helper'

describe 'Testing unit level properties of accounts' do
  before do
    Posting.dataset.destroy
    Account.dataset.destroy

    @original_password = 'mypassword'
    @account = CreateAccount.call(
      username: 'soumya.ray',
      email: 'sray@nthu.edu.tw',
      password: @original_password)
  end

  it 'HAPPY: should hash the password' do
    _(@account.password_hash).wont_equal @original_password
  end

  it 'HAPPY: should re-salt the password' do
    hashed = @account.password_hash
    @account.password = @original_password
    @account.save
    _(@account.password_hash).wont_equal hashed
  end
end

describe 'Testing Account resource routes' do
  before do
    Posting.dataset.destroy
    Account.dataset.destroy
  end

  describe 'Creating new account' do
    before do
      registration_data = {
        username: 'test.name',
        password: 'mypass',
        email: 'test@email.com' }
      @req_body = registration_data.to_json
    end

    it 'HAPPY: should create a new unique account' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/accounts/', @req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not create accounts with duplicate usernames' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      post '/api/v1/accounts/', @req_body, req_header
      post '/api/v1/accounts/', @req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end
  end


  describe 'Account spec' do
    it 'SAD: should not get invalid account' do
      get '/api/v1/accounts/' + SAD_ACCOUNT_UID

      last_response.status.must_equal 200
      result = JSON.parse last_response.body
      result['data'].must_be_nil
    end

    it 'HAPPY: should create a new account' do
      puts '# Create a new Account'
      post '/api/v1/accounts',
           {uid: HAPPY_ACCOUNT_UID1, username: HAPPY_ACCOUNT_NAME1, email: HAPPY_EMAIL, password: HAPPY_PASSWORD}.to_json,
           'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 200
      Account.count.must_be :>, 0

      puts '# Authenticate account just created'
      post '/api/v1/accounts/authenticate',
            {uid: HAPPY_ACCOUNT_UID1, password: HAPPY_PASSWORD}.to_json,
            'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 200
    end

    it 'HAPPY: should get an existed account' do
      post '/api/v1/accounts',
           {uid: HAPPY_ACCOUNT_UID2, username: HAPPY_ACCOUNT_NAME2, password: HAPPY_PASSWORD}.to_json,
           'CONTENT_TYPE' => 'application/json'

      get '/api/v1/accounts/' + HAPPY_ACCOUNT_UID2

      last_response.status.must_equal 200
      result = JSON.parse last_response.body
      result['data']['username'].must_equal HAPPY_ACCOUNT_NAME2
    end

    it 'SAD: Authenticate with wrong uid input' do
      post '/api/v1/accounts/authenticate',
            {uid: SAD_ACCOUNT_UID, password: HAPPY_PASSWORD}.to_json,
            'CONTENT_TYPE' => 'application/json'

      last_response.status.must_equal 403
    end
  end
end
