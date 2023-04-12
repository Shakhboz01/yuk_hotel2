class Billet < ApplicationRecord
  belongs_to :user
  belongs_to :waste_paper_proportion

  validates :quantity, presence: true
  def self.ransackable_associations(auth_object = nil)
    ["user", "waste_paper_proportion"]
  end
end
