class GrassrootsController < ApplicationController
  def index
    respond_to do |format|
      format.html # index.html.erb
    end
  end
  
  
  # GET /vote
  # GET /vote.json
  def vote
    if user_signed_in?
      @idea = Idea.find(params[:idea_id])
      @vote = params[:vote]
    
      if @vote == "yae"
        @idea.yae_votes+=1
      else 
        @idea.nae_votes+=1
      end
    
      @idea.rank = @idea.calculate_rank

      respond_to do |format|
        if @idea.save
          format.json { head :ok }
        else
          format.json { render :json => @idea.errors, :status => :unprocessable_entity }
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
      @idea.rank = 1
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
