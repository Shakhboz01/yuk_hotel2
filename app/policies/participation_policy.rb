class ParticipationPolicy < ApplicationPolicy
  def manage?
    user_is_manager?
  end
end
