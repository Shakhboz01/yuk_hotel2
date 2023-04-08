class ExpenditurePolicy < ApplicationPolicy
  def manage?
    user_is_manager?
  end

  def admin?
    user_is_manager?
  end
end
