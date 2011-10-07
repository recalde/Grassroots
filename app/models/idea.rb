class Idea < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  
  def category_name
    category.name if category
  end
  
  def user_alias
    user.alias if user
  end
  
  def vote_tally
    yae_votes - nae_votes
  end
  
  def total_votes
    yae_votes + nae_votes
  end
  
  def calculate_rank
    total_votes + yae_votes
  end
  
end
