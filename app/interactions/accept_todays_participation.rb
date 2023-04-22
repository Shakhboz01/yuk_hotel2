class AcceptTodaysParticipation < ActiveInteraction::Base
  array :users_particioation_status

  def execute
    return unless Participation.allowed.empty?
    return errors.add(:base, 'No data accepted') if users_particioation_status.empty?

    users_particioation_status.to_h.each do |user_id, status|
      Participation.create(status: status.to_i, user_id: user_id)
    end
  end
end
