class AddNameToWastePaperProportions < ActiveRecord::Migration[7.0]
  def change
    add_column :waste_paper_proportions, :name, :string
  end
end
