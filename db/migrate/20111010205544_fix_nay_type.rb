class FixNayType < ActiveRecord::Migration
  def up
    change_column :ideas, :nay_votes, :integer
  end
end
