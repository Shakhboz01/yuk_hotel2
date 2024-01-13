class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  has_many :participations
  has_many :shifts
  enum role: %i[админ менеджер другой]
  validates :name, uniqueness: true

  def self.devise_parameter_sanitizer
    super.tap do |sanitizer|
      sanitizer.permit(:sign_up, keys: [:name])
    end
  end

  def unfinished_shift?
    self.shifts.where(closed_at: nil).exists?
  end

  def active_for_authentication?
    super && allowed_to_use?
  end
end
