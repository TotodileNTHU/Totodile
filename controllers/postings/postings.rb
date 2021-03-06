# frozen_string_literal: true
#require_relative '../../lib/secure_db'
require 'sinatra'
#require 'json'
#require 'base64'
#require 'rbnacl/libsodium'

class TotodileAPI < Sinatra::Base
  # get specific posting by uid or pid
  # '/api/v1/postings' List all postings
  # '/api/v1/postings?uid=john8787'
  # '/api/v1/postings?id=1'

  # Get  all postings
  #to-do: write test of this route
  get '/api/v1/account_postings/:account_id' do
    content_type 'application/json'

    begin
      requesting_account = authenticated_account(env)
      target_account = Account[params[:account_id]]
      viewable_postings =
        PostingPolicy::Scope.new(requesting_account, target_account).viewable
      JSON.pretty_generate(data: viewable_postings)
    rescue
      error_msg = "FAILED to find all postings for user: #{requesting_account.id}"
      logger.info error_msg
      halt 404, error_msg
    end
  end
  #get all postings of all account
  get '/api/v1/postings/?' do
    content_type 'application/json'

    begin
      requesting_account = authenticated_account(env)
      viewable_postings =
        PostingPolicy::Scope.new(requesting_account).viewable
      JSON.pretty_generate(data: viewable_postings)
    rescue
      error_msg = "FAILED to find all postings of all account for user: #{requesting_account.id}"
      logger.info error_msg
      halt 404, error_msg
    end
  end

  #get all postings of all account without token
  get '/api/v1/postings_without_token/?' do
    content_type 'application/json'

    begin
      viewable_postings =
        Posting.all.sort_by{|post| post.created_at}.reverse
      JSON.pretty_generate(data: viewable_postings)
    rescue
      error_msg = "FAILED to find all postings of all account for user: #{requesting_account.id}"
      logger.info error_msg
      halt 404, error_msg
    end
  end

  # Get particular posting for an account
  get '/api/v1/postings/:id' do
    content_type 'application/json'

    begin
      posting = Posting[params[:id]]
      posting.full_details.to_json
      
      # check_policy = PostingPolicy.new(account, posting)
      # raise unless check_policy.can_view_posting?
      # posting.full_details
      #        .merge(policies: check_policy.summary)
      #        .to_json
      
    rescue => e
      error_msg = "POSTING NOT FOUND: \"#{params[:id]}\""
      logger.error e.inspect
      halt 401, error_msg
    end
  end



end
