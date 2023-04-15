class SausagePolicy < ApplicationPolicy
  def access?
    user_is_manager?
  end

  def special_access?
    user_is_manager? || user.оператор?
  end

  def manage?
    user_is_admin?
  end
end