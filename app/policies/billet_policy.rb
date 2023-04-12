class BilletPolicy < ApplicationPolicy
  def admin?
    user_is_admin?
  end

  def access?
    user_is_manager? || user.заготовщик?
  end

  def manage?
    user_is_manager?
  end
end
