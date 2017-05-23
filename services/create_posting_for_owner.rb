# Service object to create a new posting for an owner
class CreatePostingForOwner
  def self.call(owner_id:, name:, repo_url: nil)
    owner = Account[owner_id]
    saved_posting = owner.add_owned_posting(name: name)
    saved_posting.repo_url = repo_url if repo_url
    saved_posting.save
  end
end
