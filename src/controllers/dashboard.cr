class Dashboard < Application

  @title = "Dashboard"
  @description = "General System Metrics"
  layout "layout_full.cr"

  def index
    respond_with do
      html template("dashboard.cr")
    end
  end

  def show_loading
    <<-ANIMATION
      <div class="gra-loading-dots" style="margin:auto; padding: 8rem;">
         <span class="gra-loading-dot dot-1"></span>
         <span class="gra-loading-dot dot-2"></span>
         <span class="gra-loading-dot dot-3"></span>
      </div>    
    ANIMATION
  end
  
end
