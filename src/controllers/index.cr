class Index < Application
  base "/"

  def index
    respond_with do
      html template("index.slang")
    end
  end
end
