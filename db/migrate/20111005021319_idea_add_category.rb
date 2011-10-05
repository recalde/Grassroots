class IdeaAddCategory < ActiveRecord::Migration
  def up
    add_column :ideas, :category_id, :string
  end

  def down
    remove_column :ideas, :category_id
  end
end
