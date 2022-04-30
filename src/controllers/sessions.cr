class Sessions < Application

  layout ""
  skip_action :require_read
  skip_action :require_write
  skip_action :require_login
  rescue_from UserAuthenticationError, :retry_login

  # GET /sessions/ (login)
  def new
    login_form
  end

  def retry_login(e)
    end_session
    notice e.message.to_s
    login_form
  end

  # POST /sessions/ (verify)
  def create
    login = User.authenticate!(params["username"], params["password"])
    !!login ? current_user(params["username"]) : raise UserAuthenticationError.new("Login failed.")
    redirect_to Home.index
  end

  # DELETE /sessions/close
  def destroy
    end_session
    notice "Thank you for using #{App::NAME}."
    login_form
  end

  private def login_form
    respond_with do
      html template("login.cr")
    end
  end

end
