class Home < Application

  @title = App::NAME
  @description = App::DESC

  base "/"

  def index
    tone :random
    theme :night

    respond_with do
      html template("index.slang")
    end
  end

end
