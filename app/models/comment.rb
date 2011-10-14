class Comment < ActiveRecord::Base
  acts_as_nested_set
  belongs_to :idea
  belongs_to :user
  
  def user_alias
    user.alias if user
  end
  
end
