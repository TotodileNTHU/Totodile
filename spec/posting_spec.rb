require_relative './spec_helper'

describe 'Testing Posting resource routes' do
  before do
    Posting.dataset.destroy
    Account.dataset.destroy
  end

  describe 'Creating new owned posting for account owner' do
    before do
      @account = CreateAccount.call(
        name: 'soumya.ray',
        email: 'sray@nthu.edu.tw',
        password: 'mypassword')
    end

    it 'HAPPY: should create a new owned posting for account' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { content: 'content of demo posting' }.to_json
      post "/api/v1/accounts/#{@account.id}/owned_postings/",
           req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

  end

  describe 'Finding existing postings' do
    before do
      @my_account = CreateAccount.call(
        name: 'soumya.ray',
        email: 'sray@nthu.edu.tw',
        password: 'mypassword')

      @other_account = CreateAccount.call(
        name: 'lee123',
        email: 'lee@nthu.edu.tw',
        password: 'leepassword')

      @my_posts = []
      3.times do |i|
        @my_posts << @my_account.add_owned_posting(
          content: "content of posting of account #{@my_account.id}-#{i}")
        @other_account.add_owned_posting(
          content: "content of posting of account #{@other_account.id}-#{i}")
      end

    end

    it 'HAPPY: should find an existing posting' do
      new_posting = @my_posts.first

      auth = AuthenticateAccount.call(name: 'soumya.ray',
                                      password: 'mypassword')

      auth_headers = { 'HTTP_AUTHORIZATION' => "Bearer #{auth[:auth_token]}" }
      get "/api/v1/postings/7", nil, auth_headers
      get "/api/v1/postings/#{new_posting.id}", nil, auth_headers
      _(last_response.status).must_equal 200

      results = JSON.parse(last_response.body)
      _(results['id']).must_equal new_posting.id

    end

    it 'SAD: should not find non-existent postings' do
      get "/api/v1/postings/#{invalid_id(Posting)}"
      _(last_response.status).must_equal 401
    end
  end

  describe 'Get index of all postings for an account' do
    before do
      @my_account = CreateAccount.call(
        name: 'soumya.ray',
        email: 'sray@nthu.edu.tw',
        password: 'mypassword')

      @other_account = CreateAccount.call(
        name: 'lee123',
        email: 'lee@nthu.edu.tw',
        password: 'leepassword')

      @my_posts = []
      3.times do |i|
        @my_posts << @my_account.add_owned_posting(
          content: "content of posting of account #{@my_account.id}-#{i}")
        @other_account.add_owned_posting(
          content: "content of posting of account #{@other_account.id}-#{i}")
      end

    end

    it 'HAPPY: should find all postings for an account' do
      auth = AuthenticateAccount.call(name: 'soumya.ray',
                                      password: 'mypassword')

      auth_headers = { 'HTTP_AUTHORIZATION' => "Bearer #{auth[:auth_token]}" }
      result = get "/api/v1/accounts/#{@my_account.id}/postings", nil, auth_headers
      _(result.status).must_equal 200
      posts = JSON.parse(result.body)

      valid_ids = @my_posts.map(&:id)

      #code of teacher is 5 rather than 3,
      #it is because 3 owned projects + 2 collaborate projects
      #however,now we only has owned posings, and there is no collaborate posintg
      _(posts['data'].count).must_equal 3
      posts['data'].each do |post|
        _(valid_ids).must_include post['id']
      end
    end
  end
end
