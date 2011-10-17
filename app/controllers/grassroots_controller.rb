class GrassrootsController < ApplicationController
  def index
    @categories = Category.all
    @excludeBody = true
    render
  end 
  
  def about
    @tab_name = "About"
    render
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
      
      @vote = IdeaVote.new()
      @vote.user_id = current_user.id
      @vote.idea_id = @idea.id
      @vote.vote = 'yae'
      @vote.save
      
      respond_to do |format|
        format.json { render :json => @idea, :status => :created, :location => @idea }
      end
    end
  end

  # GET /new-comment
  # GET /new-comment.json
  def new_comment
    if user_signed_in?
      @comment = Comment.create!(:comment => params[:comment])
      @comment.idea_id = params[:idea_id]
      
      if params[:parent_id] && params[:parent_id] != 0
        @comment.parent_id = params[:parent_id]
      end
      
      @comment.user_id = current_user.id
      @comment.save
      
      respond_to do |format|
        format.json { render :json => @comment, :status => :created }
      end
    end
  end
  
  # POST /delete_comment
  def delete_comment
    @comment = Comment.find(params[:id])
    
    if current_user.alias == "Rob" || @comment.user_id = current_user.id
      
      if @comment.leaf?
        @comment.destroy
      else
        @comment.comment = '[deleted]'
        @comment.save
      end
      
      render :json => { 
            :status => :ok, 
            :message => "Success!",
            :html => "...insert html..."
          }.to_json
          
    end
    
  end
  
end
