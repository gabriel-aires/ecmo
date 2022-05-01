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
      <div class="gra-loading-dots" style="margin:auto; padding: 7rem;">
         <span class="gra-loading-dot gra-green-bg dot-1"></span>
         <span class="gra-loading-dot gra-yellow-bg dot-2"></span>
         <span class="gra-loading-dot gra-red-bg dot-3"></span>
      </div>    
    ANIMATION
  end
  
end
