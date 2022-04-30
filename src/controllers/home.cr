class Home < Application

  @title = App::NAME
  @description = App::DESC

  base "/"

  def index
    respond_with do
      html template("index.cr")
    end
  end

end
