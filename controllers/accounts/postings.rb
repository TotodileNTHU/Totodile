require 'sinatra'

# /api/v1/postings routes only
class TotodileAPI < Sinatra::Base
  # Get all postings for an account
  get '/api/v1/accounts/:account_id/postings/?' do
    content_type 'application/json'

    begin
      target_account = Account[params[:account_id]]

      viewable_postings =
        target_account.owned_postings.sort_by{|post| post.created_at}.reverse
      JSON.pretty_generate(data: viewable_postings)
    rescue
      error_msg = "FAILED to find posting for user: #{params[:account_id]}"
      logger.info error_msg
      halt 404, error_msg
    end
  end

  # Make a new posting
  post '/api/v1/accounts/:id/owned_postings/?' do
    begin
      new_posting_data = JSON.parse(request.body.read)
      saved_posting = CreatePostingForOwner.call(
        owner_id: params[:id],
        uid: new_posting_data['uid'],
        content: new_posting_data['content']
      )
      new_location = URI.join(@request_url.to_s + '/',
                              saved_posting.id.to_s).to_s
    rescue => e
      logger.info "FAILED to create new posting: #{e.inspect}"
      halt 400
    end

    status 201
    headers('Location' => new_location)
  end
end
