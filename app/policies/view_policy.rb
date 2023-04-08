class ViewPolicy < ApplicationPolicy
  def access?
    user_is_manager?
  end

  def product_access?
    user_is_manager? || user.разгрузчик?
  end

  def admin?
    user_is_admin?
  end
end
