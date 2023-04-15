class MachineSizePolicy < ApplicationPolicy
  def access?
    user_is_manager?
  end

  def manage?
    user_is_admin?
  end
end