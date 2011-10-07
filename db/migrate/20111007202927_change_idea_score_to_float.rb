class ChangeIdeaScoreToFloat < ActiveRecord::Migration
  def up
    change_column :ideas, :rank, :float
  end
end
