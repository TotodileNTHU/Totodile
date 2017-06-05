# frozen_string_literal: true

# Policy to determine if an account can view/edit/delete a particular posting
class CommentPolicy
  def initialize(account, comment)
    @account = account
    @comment = comment
  end

  def can_view_comment?
    true
  end

  def can_edit_comment?
    false
  end

  def can_delete_comment?
    false
  end

  def summary
    {
      view_posting: can_view_comment?,
      edit_posting: can_edit_comment?,
      delete_posting: can_delete_comment?
    }
  end

end
