class RenameCommentParentId < ActiveRecord::Migration
  def up
    rename_column :comments, :idea_id, :parent_id
  end

  def down
    rename_column :comments, :parent_id, :idea_id
  end
end
