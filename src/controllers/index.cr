class Index < Application
  base "/"

  def index
    redirect_to Dashboard.index
  end
end
