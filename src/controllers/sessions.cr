class Sessions < Application
  layout ""
  skip_action :require_read
  skip_action :require_write

  # GET /sessions/new (login)
  def new
    respond_with do
      html template("login.slang")
    end
  end

  # POST /sessions/create (verify)
  def create
    true
  end

  # DELETE /sessions/destroy (logout)
  def destroy
    true
  end

end
