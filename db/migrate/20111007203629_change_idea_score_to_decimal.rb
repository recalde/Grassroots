class ChangeIdeaScoreToDecimal < ActiveRecord::Migration
  def up
    change_column :ideas, :rank, :decimal
  end
end
