class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  enum role: %i[другой админ менеджер продавец упаковщик колбасник cмеситель разгрузчик]
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
end
