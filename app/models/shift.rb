class Shift < ApplicationRecord
  belongs_to :user
  before_create :check_unclosed_shifts
  before_update :send_closed_message
  after_create :send_creation_message

  scope :unclosed, -> { where(closed_at: nil) }

  def list_expenditures
    expenditures = Expenditure.where("created_at > ?", created_at)
    unless closed_at.nil?
      expenditures = expenditures.where("created_at < ?", closed_at)
    end
    expenditures
  end

  def calculate_total_expenditure
    return 0 if self.list_expenditures.nil?

    self.list_expenditures.sum(:price)
  end

  def list_top_ups
    top_ups = TopUp.where("created_at > ?", created_at)
    unless closed_at.nil?
      top_ups = top_ups.where("created_at < ?", closed_at)
    end
    top_ups
  end

  def total_top_up
    return 0 if self.list_top_ups.nil?

    self.list_top_ups.sum(:price)
  end

  private

  def check_unclosed_shifts
    shift = Shift.unclosed
    return if shift.empty?

    errors.add(:base, "Перед тем как создать новую смену, вам необходимо закрыть другие смены")
  end

  def send_creation_message
    SendMessage.run!(
      message: "<b>СМЕНА ОТКРЫТ</b>\n#{user.name}"
    )
  end

  def send_closed_message
    self.total_expenditure = calculate_total_expenditure
    self.total_income = total_top_up
    self.closed_at = DateTime.current
    SendMessage.run!(message: "<b>Смена закрыт</b>\n" \
                     "Открылся в: #{created_at.strftime("%Y-%m-%d %H:%M")}\n" \
                     "Закрылся в: #{closed_at.strftime("%Y-%m-%d %H:%M")}\n" \
                     "Итого приход: #{total_income.to_i} сум\n" \
                     "Итого расход: #{calculate_total_expenditure.to_i} сум\n"\
                     "Остаток: #{calculate_total_expenditure.to_i} сум\n"\
                     "#{user.name}"
                    )
  end
end
