# frozen_string_literal: true

require_relative './spec_helper'

describe 'Testing Comment resource routes' do
  before do
    Comment.dataset.destroy
    Posting.dataset.destroy
    Account.dataset.destroy

    @new_account = CreateAccount.call(
      name: 'test.name',
      email: 'test@email.com', password: 'mypassword')
  end

  describe 'Creating new comments for postings' do

    it 'HAPPY: should add a new comment for an existing posting' do
      existing_posting = Posting.create(content: 'Demo Posting Content')

      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { content: 'Demo Comment Content'}.to_json
      post "/api/v1/accounts/#{@new_account.id}/postings/#{existing_posting.id}/comments",
           req_body, req_header
      _(last_response.status).must_equal 201
      _(last_response.location).must_match(%r{http://})
    end

    it 'SAD: should not add a comment for non-existant posting' do
      req_header = { 'CONTENT_TYPE' => 'application/json' }
      req_body = { content: 'Demo Comment Content' }.to_json
      post "/api/v1/accounts/#{@new_account.id}/postings/#{invalid_id(Posting)}/comments",
           req_body, req_header
      _(last_response.status).must_equal 400
      _(last_response.location).must_be_nil
    end

  end

  describe 'Getting comments' do
    it 'HAPPY: should find existing comment' do
      posting = Posting.create(content: 'Demo Posting Content')

      comment = posting.add_owned_comment(content: 'Demo Comment Content')
      get "/api/v1/postings/#{posting.id}/comments/#{comment.id}"
      _(last_response.status).must_equal 200
      parsed_comment = JSON.parse(last_response.body)['data']['comment']
      _(parsed_comment['type']).must_equal 'comment'
    end

    it 'SAD: should not find non-existant posting and comment' do
      post_id = invalid_id(Posting)
      comment_id = invalid_id(Comment)
      get "/api/v1/postings/#{post_id}/comments/#{comment_id}"
      _(last_response.status).must_equal 404
    end

    it 'SAD: should not find non-existant comment for existing posting' do
      post_id = Posting.create(content: 'Demo Posting Content').id
      comment_id = invalid_id(Comment)
      get "/api/v1/postings/#{post_id}/comments/#{comment_id}"
      _(last_response.status).must_equal 404
    end
  end
end
