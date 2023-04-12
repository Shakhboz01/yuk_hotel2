class WastePaperProportion < ApplicationRecord
  has_many :proportion_details, dependent: :destroy
end
