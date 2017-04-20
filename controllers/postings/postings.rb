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

  key = [SecureDB.config.secret_key].pack('H*')
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
    content_type 'application/json'
    begin
      new_data = JSON.parse(request.body.read)
      new_data['created_time'] = Time.now
      user = User.find(uid: new_data['uid'])
      if user
        new_data['user_id'] = user.id
        new_data['content'] = Base64.strict_encode64(box.encrypt(new_data['content']))
        print(new_data)
        new_post = Posting.new(new_data)
        if new_post.save
          logger.info "NEW POSTING STORED: #{new_post.id}"
          redirect '/api/v1/postings?id=' + new_post.id.to_s
        else
          halt 400, "Could not store posting: #{new_post}"
        end
      else
        halt 400, 'invalid uid'
      end
    rescue => e
      logger.info "FAILED to create new posting: #{e.inspect}"
      status 400
    end
  end
  
end