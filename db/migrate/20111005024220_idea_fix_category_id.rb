class IdeaFixCategoryId < ActiveRecord::Migration
    remove_column :ideas, :category_id
    add_column :ideas, :category_id, :integer
  end

  def down
    remove_column :ideas, :category_id
    add_column :ideas, :category_id, :string
end
