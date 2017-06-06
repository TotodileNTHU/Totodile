# frozen_string_literal: true

# Policy to determine if account can view a posting
class PostingPolicy
  # Scope of posting policies
  #Creation of this class is in case that the policy may change
  #in other words, an acoount may become unable to see all postings in scope
  class Scope
    # default of target_account is nil
    def initialize(current_account,target_account=nil)
      if target_account.nil?
        @scope =  Posting.all.sort_by{|post| post.created_at}.reverse
      else    #if target_account is not nil, means that current_account want to get postings of target_account
        @scope = target_account.owned_postings.sort_by{|post| post.created_at}.reverse
      end
    end

    def viewable
      @scope
    end
  end
end
