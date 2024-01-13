module ShiftIsPresent
  extend ActiveSupport::Concern

  included do
    validate :shift_is_present
  end

  def shift_is_present
    return if Shift.unclosed.exists?

    errors.add(:base, "ERROR: Смена не открыто!")
  end
end
