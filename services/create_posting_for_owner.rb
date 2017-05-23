# Service object to create a new posting for an owner
class CreatePostingForOwner
  def self.call(owner_id:, content:, uid: nil)
    owner = Account[owner_id]
    saved_posting = owner.add_owned_posting(content: content)
    saved_posting.uid = uid if uid
    saved_posting.save
  end
end
