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
    &#9888
     "&#127968 № #{booking.home.number}\n" \
     "&#128181 #{number_to_currency(price, unit: '')}\n" \
     "&#129333 #{guest_info.name}\n"

    message << "Комментарие: #{comment}" unless comment.empty?
    SendMessage.run(message: message)
  end
end
