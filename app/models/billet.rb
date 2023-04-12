class Billet < ApplicationRecord
  belongs_to :user
  belongs_to :waste_paper_proportion
end
