require 'sinatra'

# /api/v1/postings routes only
class TotodileAPI < Sinatra::Base


  get '/api/v1/postings/:posting_id/comments/:id/?' do
    content_type 'application/json'

    begin
      comment = Comment.where( id: params[:id]).first
      halt(404, 'Comment not found') unless comment
      JSON.pretty_generate(data: {
                             comment: comment
                           })
    rescue => e
      error_msg = "FAILED to process GET comment request: #{e.inspect}"
      logger.info error_msg
      halt 400, error_msg
    end
  end

  # Get all comments for an posting
  get '/api/v1/postings/:posting_id/comments/?' do
    content_type 'application/json'

    begin
      requesting_account = authenticated_account(env)
      target_posting = Posting[params[:posting_id]]

      viewable_comments =
        CommentPolicy::Scope.new(requesting_account, target_posting).viewable
      JSON.pretty_generate(data: viewable_comments)
    rescue => e
      error_msg = "FAILED to find comments for posting: #{params[:posting_id]}"
      logger.info error_msg
      halt 404, error_msg, e.inspect
    end
  end

  # Make a new comment
  post '/api/v1/accounts/:account_id/postings/:posting_id/comments/?' do
    begin
      new_comment_data = JSON.parse(request.body.read)
      saved_comment= CreateCommentForOwner.call(
        owner_id: params[:posting_id],
        commenter: params[:account_id],
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
