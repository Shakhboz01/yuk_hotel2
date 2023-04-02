class ProductPolicy
  def manage?
    user_is_manager?
  end

  def admin?
    user_is_admin?
  end
end