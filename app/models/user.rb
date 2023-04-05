class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  enum role: %i[другой админ менеджер продавец упаковщик колбасник cмеситель разгрузчик]
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true

  def self.devise_parameter_sanitizer
    super.tap do |sanitizer|
      sanitizer.permit(:sign_up, keys: [:name])
    end
  end
end
