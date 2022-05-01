class Dashboard < Application

  @title = "Dashboard"
  @description = "General System Metrics"

  layout "layout_full.cr"

  def index
    respond_with do
      html template("dashboard.cr")
    end
  end

end