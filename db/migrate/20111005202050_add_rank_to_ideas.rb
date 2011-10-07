class AddRankToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :rank, :integer
  end
end
