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

  key = [SecureDB.config.DB_KEY].pack('H*')
  box = RbNaCl::SimpleBox.from_secret_key(key)

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
    begin
      new_data = JSON.parse(request.body.read)
      result = CreatePosting.call(new_data)

    rescue => e
      error_msg = "FAILED to create new config: #{e.inspect}"
      logger.info error_msg
      halt 400, error_msg
    end

    status 201
    headers('Location' => [@request_url.to_s, saved_config.id].join('/'))

    end

end
