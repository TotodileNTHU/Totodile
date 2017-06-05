# Service object to create a new posting for an owner
class CreateCommentForOwner
  def self.call(owner_id:, content:, commenter:)
    owner = Posting[owner_id]    # here,owner is posting which has this comment
    saved_comment = owner.add_owned_comment(content: content, commenter:commenter)
    saved_comment.commenter = commenter
    saved_comment.save
  end
end
