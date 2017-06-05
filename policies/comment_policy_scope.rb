# frozen_string_literal: true

# Policy to determine if account can view a comment for all comments of a posting
class CommentPolicy

  class Scope

    def initialize(current_account,target_posting)
      @scope = target_posting.comments
    end

    def viewable
      @scope
    end
  end
end
