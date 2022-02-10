class Sessions < Application

  layout ""
  skip_action :require_read
  skip_action :require_write
  skip_action :require_login
  rescue_from UserAuthenticationError, :retry_login

  # GET /sessions/ (login)
  def new
    tone :success
    login_form
  end

  def retry_login(e)
    end_session
    notice e.message.to_s
    tone :error
    login_form
  end

  # POST /sessions/ (verify)
  def create
    login = User.authenticate!(params["username"], params["password"])
    !!login ? current_user(params["username"]) : raise UserAuthenticationError.new("Login failed.")
    tone :info
    redirect_to Home.index
  end

  # DELETE /sessions/close
  def destroy
    end_session
    notice "Your session is finished. Thank you for using #{App::NAME}."
    tone :info
    login_form
  end

  private def login_form
    respond_with do
      html template("login.slang")
    end
  end

end
