# frozen_string_literal: true

# Policy to determine if an account can view/edit/delete a particular posting
class PostingPolicy
  def initialize(account, posting)
    @account = account
    @posting = posting
  end

  def can_view_posting?
    true
  end

  def can_edit_posting?
    false
  end

  def can_delete_posting?
    false
  end

  def summary
    {
      view_posting: can_view_posting?,
      edit_posting: can_edit_posting?,
      delete_posting: can_delete_posting?
    }
  end

  private

  def account_is_owner?
    @posting.owner == @account
  end

end
