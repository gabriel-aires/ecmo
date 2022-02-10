module SessionUtils

  def current_user
    # username should be unique and is used instead of id in order to support network users
    # session data is stored in a cryptographically signed cookie (tamper-proof)
    @_current_user ||= session["username"]? ? User.new session["username"].to_s : nil
  end

  def current_user (username : String)
    session["username"] = username
  end

  def notice
    msg = session["notice"].to_s
    notice ""
    msg
  end

  def notice?
    session["notice"]? ? (session["notice"].to_s.size > 0) : false
  end

  def notice (message : String)
    session["notice"] = message
  end

  def tone
    @_tone ||= session["tone"]? ? session["tone"].to_s : "blue"
  end

  def tone(color : String)
    @_tone = session["tone"] = (color.in?(["green", "orange", "red", "black"]) ? color : "blue")
  end

  def tone(level : Symbol)
    case level
    when :success then  tone "green"
    when :warn    then  tone "orange"
    when :error   then  tone "red"
    when :unknown then  tone "black"
    else                tone "blue"
    end
  end

  def end_session
    session.clear
    @_current_user = nil
  end

end
