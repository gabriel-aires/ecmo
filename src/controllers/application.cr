require "uuid"

abstract class Application < ActionController::Base

  force_ssl
  layout "layout.slang"
  Log = ::App::Log.for("controller")
  before_action :set_request_id
  before_action :set_date_header
  before_action :require_read, only: [:index, :show]
  before_action :require_write, except: [:index, :show]

  def set_request_id
    request_id = UUID.random.to_s
    Log.context.set client_ip: client_ip, request_id: request_id
    response.headers["X-Request-ID"] = request_id
  end

  def set_date_header
    response.headers["Date"] = HTTP.format_time(Time.utc)
  end

  def require_read
    true
  end

  def require_write
    false
  end

  def current_user
    # username should be unique and is used instead of id in order to support network users
    # session data is stored in a cryptographically signed cookie (tamper-proof)
    @_current_user ||= session["username"]? && User.new session["username"]
  end

  def current_user=(username : String)
    session["username"] = username
  end

  def notice
    session.delete "notice"
  end

  def notice?
    session["notice"]?
  end

  def notice=(message : String)
    session["notice"] = message
  end

  def ui_status
    @_ui_status ||= session["status"]? ? session["status"].to_s : "blue"
  end

  def ui_status=(color : String)
    @_ui_status = session["status"] = ["green", "orange", "red", "black"].includes? color ? color : "blue"
  end

  def ui_status=(level : Symbol)
    case level
    when :success then  status = "green"
    when :warn    then  status = "orange"
    when :error   then  status = "red"
    when :unknown then  status = "black"
    else                status = "blue"
    end
  end

  def end_session
    session.clear
    @_current_user = nil
  end

end
