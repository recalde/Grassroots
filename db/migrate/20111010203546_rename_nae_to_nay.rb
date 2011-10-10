class RenameNaeToNay < ActiveRecord::Migration
  def up
    rename_column :ideas, :nae_votes, :nay_votes
  end

  def down
    rename_column :ideas, :nay_votes, :nae_votes
  end
end
