class TopUp < ApplicationRecord
  include ActionView::Helpers
  include ShiftIsPresent
  belongs_to :booking
  belongs_to :guest_info
  validates_presence_of :price
  enum payment_type: %i[наличные карта click другие]
  after_create :send_notif

  private

  def send_notif
    message =
     "<b>Приём оплаты:</b>\n" \
     "Номер комнаты: #{booking.home.number}\n" \
     "Цена: #{number_to_currency(price, unit: '')}\n" \
     "Тип оплаты: #{payment_type}\n" \
     "Гость: #{guest_info.name}\n"

    message << "Комментарие: #{comment}" unless comment.empty?
    SendMessage.run(message: message)
  end
end
