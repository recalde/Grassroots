class RemoveTotalVotesFromIdeas < ActiveRecord::Migration
  def up
    remove_column :ideas, :total_votes
  end
end
