class Booking < ApplicationRecord
  include ActionView::Helpers
  include ShiftIsPresent
  belongs_to :home
  validates :number_of_people, comparison: { greater_than: 0 }
  has_many :guest_infos
  has_many :top_ups
  after_create :notify_tg
  before_update :notify_tg_on_finish, if: :saved_change_to_finished_at

  private

  def notify_tg
      message = "<b>Комнатa №#{home.number} теперь oткрыто!</b>"
      SendMessage.run(message: message)
  end

  def notify_tg_on_finish
    message =
      "<b>Комнатa №#{home.number} теперь закрыто!</b>\n" \
      "Открылся в: #{booking.created_at.to_datetime}\n" \
      "Закрылся в: #{DateTime.current.to_datetime}\n" \
      "Итого приём оплаты от этой комнаты: #{number_to_currency(top_ups&.sum(:price))}\n" \
      "Итого количество гостей: #{guest_infos&.count}"

    SendMessage.run(message: message)
  end
end
