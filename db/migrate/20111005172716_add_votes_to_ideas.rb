class AddVotesToIdeas < ActiveRecord::Migration
  def change
    add_column :ideas, :yae_votes, :integer
    add_column :ideas, :nae_votes, :integer
    add_column :ideas, :total_votes, :integer
  end
end
