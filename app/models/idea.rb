class Idea < ActiveRecord::Base
  belongs_to :category
  belongs_to :user
  has_many :idea_vote, :dependent => :destroy
  
  def category_name
    category.name if category
  end
  
  def user_alias
    user.alias if user
  end
  
  def vote_tally
    yae_votes - nay_votes
  end
  
  def total_votes
    yae_votes + nay_votes
  end
  
  def calculate_rank
    hot
  end
  
  def seo_url
    "#{id}/#{subject.parameterize}"
  end
  

  def epoch_seconds
    epoch = DateTime.new(1970, 1, 1)
    
    if created_at 
      td = created_at - epoch
    else
      td = DateTime.now - epoch
    end
    
    return td.seconds #td.days.round * 86400 + td.seconds / 1000000
    
  end

  def score
    2 * yae_votes - nay_votes
  end

  def hot
    s = vote_tally
    l = [s.abs, 1].max
    order = Math.log10(l)
    if s > 0
      sign = 1
    elsif s < 0
      sign = -1
    else
      sign = 0
    end
    
    seconds = epoch_seconds - 1134028003
    score = order + sign * seconds / 180000
    
    logger.debug "**** CALCULATING SCORE ****"
    logger.debug "score: #{s}"
    logger.debug "order: #{order}"
    logger.debug "seconds: #{seconds}"
    logger.debug "score: #{score}"

    
    return score
  end
      
end
