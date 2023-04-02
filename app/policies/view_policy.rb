class ViewPolicy < ApplicationPolicy
  def access?
    user_is_manager?
  end
end
