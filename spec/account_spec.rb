require_relative './spec_helper'

describe 'Testing unit level properties of accounts' do
  before do

    Posting.dataset.destroy
    Account.dataset.destroy

    @original_password = 'mypassword'
    @account = CreateAccount.call(
      name: 'soumya.ray',
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
        name: 'test.name',
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


  describe 'Finding an existing account' do
    before do
      @new_account = CreateAccount.call(
        name: 'test.name',
        email: 'test@email.com', password: 'mypassword')
      @new_postings = (1..3).map do |i|

        # method of add_owned_posting is created by sequel,
        # when we declare account has one_to_many relationshop with owned_posting in models/account.rb
        # owned_posting is naming, its class is Posting
        @new_account.add_owned_posting(content: "this is content of posting #{i}")
      end
    end

    it 'HAPPY: should find an existing account' do
      get "/api/v1/accounts/#{@new_account.id}"
      _(last_response.status).must_equal 200

      results = JSON.parse(last_response.body)
      _(results['data']['id']).must_equal @new_account.id
      3.times do |i|
        _(results['relationships'][i]['id']).must_equal @new_postings[i].id
      end
    end

    it 'SAD: should not return wrong account' do
      get "/api/v1/accounts/#{random_str(10)}"
      _(last_response.status).must_equal 401
    end
  end
end
