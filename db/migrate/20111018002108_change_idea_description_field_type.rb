class ChangeIdeaDescriptionFieldType < ActiveRecord::Migration
  def self.up
    change_column :ideas, :description, :text
  end
end
