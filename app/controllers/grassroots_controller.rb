class GrassrootsController < ApplicationController
  def index

    render :layout => 'header_only'
  end 
  
  # GET /vote
  # GET /vote.json
  def vote
    if user_signed_in?
      @idea = Idea.find(params[:idea_id])
      vote = params[:vote]
      @ideavote = IdeaVote.where(:user_id => current_user.id, :idea_id => params[:idea_id]);
      
      # back out the old vote
      vote_changed = false
      had_vote = false
      
      if @ideavote.count > 0
        had_vote = true
        if @ideavote[0].vote != vote
          vote_changed = true
        end
        
        if @ideavote[0].vote == "yae"
          @idea.yae_votes-=1
        else 
          @idea.nay_votes-=1
        end
        @ideavote[0].destroy
      end
      
      # apply the new vote
      if !had_vote || vote_changed
        @newideavote = IdeaVote.new()
        @newideavote.user_id = current_user.id
        @newideavote.idea_id = @idea.id
        @newideavote.vote = vote
        @newideavote.save 
        if vote == "yae"
          @idea.yae_votes+=1
        else 
          @idea.nay_votes+=1
        end
      end
      
      @idea.rank = @idea.calculate_rank
      @idea.save
      
      respond_to do |format|
        format.json { 
          render :json => @idea.to_json(:methods => [:vote_tally, :category_name, :user_alias]) 
        }
      end
      
    end
  end
  
  # GET /new-idea
  # GET /new-idea.json
  def new_idea
    if user_signed_in?
      @idea = Idea.new()
      @idea.subject = params[:new_idea_subject]
      @idea.description = params[:new_idea_description]
      @idea.category_id = params[:new_idea_category_id]
      @idea.yae_votes = 1
      @idea.nay_votes = 0
      @idea.rank = @idea.calculate_rank
      @idea.user_id = current_user.id
      @idea.save
      
      @newideavote = IdeaVote.new()
      @newideavote.user_id = current_user.id
      @newideavote.idea_id = @idea.id
      @newideavote.vote = 'yae'
      @newideavote.save
      
      respond_to do |format|
        format.json { render :json => @idea, :status => :created, :location => @idea }
      end
    end
  end

end
