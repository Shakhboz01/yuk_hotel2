class GuestInfo < ApplicationRecord
  include ShiftIsPresent
  belongs_to :booking
  validates_presence_of :name
  after_create :send_notif

  private

  def send_notif
    message =
      "<b>Новый гость в комнате #{booking.home.number}</b>\n" \
      "Имя: #{name}\n" \
      "Страна: #{country}\n"

    SendMessage.run(message: message)
  end
end
