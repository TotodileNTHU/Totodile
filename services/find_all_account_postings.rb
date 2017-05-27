# Find all projects (owned and contributed to) by an account
class FindAllAccountPostings
  def self.call(id: )
    account = Account.where(id: id).first
    account.owned_postings
  end
end
