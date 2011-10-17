module ApplicationHelper
  
  def render_page_title
    if defined? @page_title
      @page_title
    else
      "Grassroots Policy"
    end
  end
  
end
