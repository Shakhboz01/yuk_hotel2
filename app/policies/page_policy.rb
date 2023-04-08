class PagePolicy < ApplicationPolicy
  def access?
    user_is_admin?
  end

  def manage?
    user_is_manager?
  end
end
