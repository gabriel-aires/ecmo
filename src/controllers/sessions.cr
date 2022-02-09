class Sessions < Application

  layout ""
  skip_action :require_read
  skip_action :require_write
  rescue_from UserAuthenticationError, :retry_login

  # GET /sessions/new (login)
  def new
    status :success
    login_form
  end

  def retry_login(e)
    end_session
    notice (e.message || "Please try again")
    status :error
    login_form
  end

  # POST /sessions/create (verify)
  def create
    login = User.authenticate!(params["username"], params["password"])
    !!login ? current_user(params["username"]) : raise UserAuthenticationError.new("Login failed.")
    status :success
    redirect_to Home.index
  end

  # DELETE /sessions/destroy (logout)
  def destroy
    end_session
    notice "Your session is finished. Thank you for using #{App::NAME}."
    status :info
    login_form
  end

  private def login_form
    respond_with do
      html template("login.slang")
    end
  end

end
