class ChangeCommentFieldType < ActiveRecord::Migration
  def self.up
    change_column :comments, :comment, :text
  end
end
