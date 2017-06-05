require 'sinatra'

# /api/v1/postings routes only
class TotodileAPI < Sinatra::Base

  # Get all comments for an posting
  get '/api/v1/postings/:posting_id/comments/?' do
    content_type 'application/json'

    begin
      requesting_account = authenticated_account(env)
      target_posting = Posting[params[:posting_id]]

      viewable_comments =
        CommentPolicy::Scope.new(requesting_account, target_posting).viewable
      JSON.pretty_generate(data: viewable_comments)
    rescue
      error_msg = "FAILED to find comments for posting: #{params[:posting_id]}"
      logger.info error_msg
      halt 404, error_msg
    end
  end

  # Make a new comment
  post '/api/v1/postings/:posting_id/owned_comments/?' do
    begin
      account = authenticated_account(env)

      new_comment_data = JSON.parse(request.body.read)
      saved_comment= CreateCommentForOwner.call(
        owner_id: params[:posting_id],
        commenter: account.id, # todo: test
        content: new_comment_data['content']
      )
      new_location = URI.join(@request_url.to_s + '/',
                              saved_comment.id.to_s).to_s
    rescue => e
      logger.info "FAILED to create new comment: #{e.inspect}"
      halt 400
    end

    status 201
    headers('Location' => new_location)
  end
end
