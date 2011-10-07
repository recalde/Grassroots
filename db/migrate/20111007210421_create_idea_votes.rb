class CreateIdeaVotes < ActiveRecord::Migration
  def change
    create_table :idea_votes do |t|
      t.integer :idea_id
      t.integer :user_id
      t.string :vote

      t.timestamps
    end
  end
end
