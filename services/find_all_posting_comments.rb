# Find all projects (owned and contributed to) by an account
class FindAllPostingComments
  def self.call(id: )
    posting = Posting.where(id: id).first
    posting.owned_comments
  end
end
