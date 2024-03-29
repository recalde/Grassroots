class IdeasController < ApplicationController
  # GET /ideas
  # GET /ideas.json
  def index
    
    limit = 15
    if params[:category_id]
      @ideas = Idea.where(:category_id => params[:category_id]).order("rank DESC").limit(limit)
    elsif params[:category_type]
      if params[:category_type] == "top"
        @ideas = Idea.order("rank DESC").limit(limit)
      elsif params[:category_type] == "new"
        @ideas = Idea.order("created_at DESC").limit(limit)
      end
    else 
      @ideas = Idea.order("rank DESC").limit(limit)
    end

    if (params[:layout])
      render :layout => params[:layout]
    else
      respond_to do |format|
        format.html
        format.json { 
          render :json => @ideas.to_json(:methods => [:vote_tally, :category_name, :user_alias, :seo_url]) 
        }
      end
    end
    


  end

  # GET /ideas/1
  # GET /ideas/1.json
  def show
    
    @idea = Idea.find(params[:id])
    @votes = IdeaVote.where(:idea_id => params[:id]);
    @comments = Comment.where(:idea_id => params[:id]).roots;
    
    @tab_name = @idea.category_name
    @show_facebook = true;
    @page_title = 'Grassroots Policy: ' + @idea.subject
    
    respond_to do |format|
      format.html { render }
      format.json { render :json => @idea }
    end
  end

  # GET /ideas/new
  # GET /ideas/new.json
  def new
    @idea = Idea.new
    
    respond_to do |format|
      format.html # new.html.erb
      format.json { render :json => @idea }
      
    end
  end

  # GET /ideas/1/edit
  def edit
    @idea = Idea.find(params[:id])
    @tab_name = @idea.category_name
    
  end

  # POST /ideas
  # POST /ideas.json
  def create
    @idea = Idea.new(params[:idea])
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

  # PUT /ideas/1
  # PUT /ideas/1.json
  def update
    @idea = Idea.find(params[:id])
    if current_user.alias == "Rob" || @idea.user_id = current_user.id

      respond_to do |format|
        if @idea.update_attributes(params[:idea])
          format.html { redirect_to @idea, :notice => 'Idea was successfully updated.' }
          format.json { head :ok }
        else
          format.html { render :action => "edit" }
          format.json { render :json => @idea.errors, :status => :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /ideas/1
  # DELETE /ideas/1.json
  def destroy
    if current_user.alias == "Rob"
      @idea = Idea.find(params[:id])
      @idea.destroy

      respond_to do |format|
        format.html { redirect_to ideas_url }
        format.json { head :ok }
      end
    end
  end
end
