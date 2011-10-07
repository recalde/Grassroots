class AddAliasIndexToUser < ActiveRecord::Migration
  def change
    add_index :users, :alias,                :unique => true
  end
end
