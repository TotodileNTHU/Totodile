# Service object to create a new posting for an owner
class CreateCommentForOwner
  def self.call(posting_id:, content:, commenter_id:)
    posting = Posting[posting_id]    # here,owner is posting which has this comment
    saved_comment = posting.add_comment(content: content, commenter_id:commenter_id)
    account = Account[commenter_id]
    saved_comment.commenter_name = account.name
    saved_comment.save
  end
end
