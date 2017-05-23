# frozen_string_literal: true
require_relative '../../lib/secure_db'
require 'sinatra'
require 'json'
require 'base64'
require 'rbnacl/libsodium'

class TotodileAPI < Sinatra::Base
  # get specific posting by uid or pid
  # '/api/v1/postings' List all postings
  # '/api/v1/postings?uid=john8787'
  # '/api/v1/postings?id=1'

  #what is env ?? 
  def authorized_affiliated_posting(env, posting_id)
    account = authenticated_account(env)
    all_postings = FindAllAccountPostings.call(id: account['id'])
    all_postings.select { |post| post.id == posting_id.to_i }.first
  rescue => e
    logger.error "ERROR finding posting: #{e.inspect}"
    nil
  end

  key = [SecureDB.config.DB_KEY].pack('H*')
  box = RbNaCl::SimpleBox.from_secret_key(key)


  # Get particular posting for an account
  get '/api/v1/posting/:id' do
    content_type 'application/json'

    posting_id = params[:id]
    posting = authorized_affiliated_posting(env, posting_id)

    if posting
      posting.to_full_json
    else
      error_msg = "POSTING NOT FOUND: \"#{posting_id}\""
      logger.info error_msg
      halt 401, error_msg
    end
  end

  #get all postings
  get '/api/v1/postings/?' do
    content_type 'application/json'

    begin
      subset = nil
      if !params[:uid].nil?
        subset = Posting.where(uid: params[:uid])
      elsif !params[:id].nil?
        subset = Posting.where(id: params[:id])
      else
        halt 200, JSON.pretty_generate(data: Posting.all)
      end

      result = []
      subset.each { |row|
        row[:content] = box.decrypt(Base64.decode64(row[:content]))
        result.push(row) }
      if result.empty?
        JSON.pretty_generate(data: 'none')
      else
        JSON.pretty_generate(data: result)
      end

    rescue => e
      logger.info "FAILED to GET message: #{e.inspect}"
      status 404
    end
  end

  post '/api/v1/postings' do
    post_data = JSON.parse(request.body.read, symbolize_names: true)

    result = CreatePosting.call(post_data)
    if !result.nil?
      content_type 'application/json'
      result.to_json
    else
      status 400
      end
  end
end
