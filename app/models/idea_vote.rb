class IdeaVote < ActiveRecord::Base
  
  belongs_to :idea
  belongs_to :user

  def user_alias
    user.alias if user
  end
  
end
