class Home < ApplicationRecord
  enum home_type: %i[hotel hostel]
  has_many :bookings
  def started_at
    self.bookings.where(finished_at: nil).last&.created_at
  end

  def total_paid_by_guests
    self.bookings.where(finished_at: nil).last&.top_ups&.sum(:price)
  end

  def number_of_guests
    self.bookings.where(finished_at: nil).last&.guest_infos&.count
  end

  def breakfast_included
    self.bookings.where(finished_at: nil).last&.breakfast_included
  end

  def active?
    self.bookings.where(finished_at: nil).exists?
  end
end
