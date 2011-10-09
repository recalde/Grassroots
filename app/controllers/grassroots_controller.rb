class GrassrootsController < ApplicationController
  def index

    render :layout => 'header_only'
  end 
  
  # GET /vote
  # GET /vote.json
  def vote
    if user_signed_in?
      @idea = Idea.find(params[:idea_id])
      @vote = params[:vote]
      @ideavote = IdeaVote.where(:user_id => current_user.id, :idea_id => params[:idea_id]);
      if @ideavote.count == 0
    
        @newideavote = IdeaVote.new()
        @newideavote.user_id = current_user.id
        @newideavote.idea_id = @idea.id
        @newideavote.vote = @vote
        @newideavote.save
            
        if @vote == "yae"
          @idea.yae_votes+=1
        else 
          @idea.nae_votes+=1
        end
    
        @idea.rank = @idea.calculate_rank

        respond_to do |format|
          if @idea.save
            format.json { render :json => @idea, :status => :created, :location => @idea }
          else
            format.json { render :json => @idea.errors, :status => :unprocessable_entity }
          end
        end
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
      @idea.nae_votes = 0
      @idea.rank = @idea.calculate_rank
      @idea.user_id = current_user.id
      respond_to do |format|
        if @idea.save
          format.html { redirect_to @idea, :notice => 'Idea was successfully created.' }
          format.json { render :json => @idea, :status => :created, :location => @idea }
        else
          format.html { render :action => "new" }
          format.json { render :json => @idea.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

end
