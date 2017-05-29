# Find all projects (owned and contributed to) by an account
class FindAllPostings
  def self.call()
    Posting.all
  end
end
