class PackagePolicy < ApplicationPolicy
  def access?
    user_is_manager?
  end

  def special_access?
    user_is_manager? || user.упаковщик?
  end

  def manage?
    user_is_admin?
  end
end