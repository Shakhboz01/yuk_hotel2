class CreateWastePaperProportions < ActiveRecord::Migration[7.0]
  def change
    create_table :waste_paper_proportions do |t|

      t.timestamps
    end
  end
end
