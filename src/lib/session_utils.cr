module SessionUtils

  def current_user
    # username should be unique and is used instead of id in order to support network users
    # session data is stored in a cryptographically signed cookie (tamper-proof)
    @_current_user ||= session["username"]? && User.new session["username"]
  end

  def current_user (username : String)
    session["username"] = username
  end

  def notice
    session.delete "notice"
  end

  def notice?
    session["notice"]?
  end

  def notice (message : String)
    session["notice"] = message
  end

  def status
    @_status ||= session["status"]? ? session["status"].to_s : "blue"
  end

  def status(color : String)
    @_status = session["status"] = (color.in?(["green", "orange", "red", "black"]) ? color : "blue")
  end

  def status(level : Symbol)
    case level
    when :success then  status "green"
    when :warn    then  status "orange"
    when :error   then  status "red"
    when :unknown then  status "black"
    else                status "blue"
    end
  end

  def end_session
    session.clear
    @_current_user = nil
  end

end
